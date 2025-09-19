#!/bin/bash
# Gerenciador de ambiente Flutter/Android no /goinfre/$USER (42)

BASE_DIR="/goinfre/$USER"
FLUTTER_VERSION="3.35.4"
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
ANDROID_SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"
NINJA_URL="https://github.com/ninja-build/ninja/releases/download/v1.11.1/ninja-linux.zip"

FLUTTER_DIR="$BASE_DIR/flutter"
ANDROID_SDK_DIR="$BASE_DIR/android-sdk"
ANDROID_SDK_TOOLS_DIR="$ANDROID_SDK_DIR/cmdline-tools/latest"
AVD_HOME="$BASE_DIR/.android/avd"
BIN_DIR="$BASE_DIR/bin"

AVD_NAME="Pixel_4_API_35"
AVD_PACKAGE="system-images;android-35;google_apis;x86_64"

ZSHRC="$HOME/.zshrc"

# =====================================================================
# FUNÇÕES
# =====================================================================

create_folders() {
    echo "==> Criando estrutura de pastas em $BASE_DIR ..."
    mkdir -p "$FLUTTER_DIR" \
             "$ANDROID_SDK_DIR/cmdline-tools" \
             "$AVD_HOME" \
             "$BASE_DIR/.pub-cache" \
             "$BASE_DIR/.gradle" \
             "$BASE_DIR/.flutter" \
             "$BASE_DIR/.dart-tool" \
             "$BIN_DIR"
    echo "✅ Estrutura criada."
}

link_caches() {
    echo "==> Redirecionando caches do HOME para o goinfre..."
    rm -rf "$HOME/.gradle" "$HOME/.pub-cache" "$HOME/.android" "$HOME/.flutter" "$HOME/.dart-tool"
    ln -sfn "$BASE_DIR/.gradle"    "$HOME/.gradle"
    ln -sfn "$BASE_DIR/.pub-cache" "$HOME/.pub-cache"
    ln -sfn "$BASE_DIR/.android"   "$HOME/.android"
    ln -sfn "$BASE_DIR/.flutter"   "$HOME/.flutter"
    ln -sfn "$BASE_DIR/.dart-tool" "$HOME/.dart-tool"
    echo "✅ Links simbólicos criados no HOME"
}

setup_env() {
    echo "==> Configurando variáveis de ambiente..."
    export FLUTTER_ROOT="$FLUTTER_DIR"
    export PATH="$FLUTTER_ROOT/bin:$PATH"
    export ANDROID_SDK_ROOT="$ANDROID_SDK_DIR"
    export PATH="$ANDROID_SDK_TOOLS_DIR/bin:$PATH"
    export PATH="$ANDROID_SDK_DIR/platform-tools:$PATH"
    export PATH="$ANDROID_SDK_DIR/emulator:$PATH"
    export ANDROID_AVD_HOME="$AVD_HOME"
    export PUB_CACHE="$BASE_DIR/.pub-cache"
    export GRADLE_USER_HOME="$BASE_DIR/.gradle"
    export PATH="$BIN_DIR:$PATH"

    link_caches

    if ! grep -q "Flutter & Android SDK (42 goinfre setup)" "$ZSHRC"; then
        echo "==> Adicionando variáveis ao ~/.zshrc..."
        cat <<EOL >> "$ZSHRC"

# >>> Flutter & Android SDK (42 goinfre setup) >>>
export FLUTTER_ROOT="/goinfre/\$USER/flutter"
export PATH="\$FLUTTER_ROOT/bin:\$PATH"

export ANDROID_SDK_ROOT="/goinfre/\$USER/android-sdk"
export PATH="\$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:\$PATH"
export PATH="\$ANDROID_SDK_ROOT/platform-tools:\$PATH"
export PATH="\$ANDROID_SDK_ROOT/emulator:\$PATH"

export ANDROID_AVD_HOME="/goinfre/\$USER/.android/avd"
export PUB_CACHE="/goinfre/\$USER/.pub-cache"
export GRADLE_USER_HOME="/goinfre/\$USER/.gradle"

export PATH="/goinfre/\$USER/bin:\$PATH"
# <<< Flutter & Android SDK <<<
EOL
    fi
}

clean_all() {
    echo "⚠️ Isso vai remover TODO o ambiente em $BASE_DIR e os links no HOME."
    read -p "Tem certeza? (y/N): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        rm -rf "$BASE_DIR/flutter" \
               "$BASE_DIR/android-sdk" \
               "$BASE_DIR/.android" \
               "$BASE_DIR/.pub-cache" \
               "$BASE_DIR/.gradle" \
               "$BASE_DIR/.flutter" \
               "$BASE_DIR/.dart-tool" \
               "$BIN_DIR"

        rm -rf "$HOME/.gradle" "$HOME/.pub-cache" "$HOME/.android" "$HOME/.flutter" "$HOME/.dart-tool"

        echo "✅ Ambiente removido de $BASE_DIR e do HOME (~)"
    else
        echo "ℹ️ Operação cancelada."
    fi
}

install_ninja() {
    echo "==> Instalando Ninja build em $BIN_DIR ..."
    mkdir -p "$BIN_DIR"
    cd "$BASE_DIR" || exit 1
    wget -q --show-progress "$NINJA_URL" -O ninja.zip
    unzip -q ninja.zip
    rm ninja.zip
    mv ninja "$BIN_DIR/"
    chmod +x "$BIN_DIR/ninja"
    echo "✅ Ninja instalado em $BIN_DIR/ninja"
}

install_sdks() {
    create_folders
    setup_env
    install_ninja

    # Flutter
    if [ ! -d "$FLUTTER_DIR/bin" ]; then
        echo "⚠️ Instalando Flutter SDK..."
        cd "$BASE_DIR" || exit 1
        wget -q --show-progress "$FLUTTER_URL" -O flutter.tar.xz
        tar -xf flutter.tar.xz && rm flutter.tar.xz
        echo "✅ Flutter SDK instalado em $FLUTTER_DIR"
    else
        echo "ℹ️ Flutter SDK já existe em $FLUTTER_DIR"
    fi

    # Android cmdline-tools
    if [ ! -d "$ANDROID_SDK_TOOLS_DIR" ]; then
        echo "⚠️ Instalando Android cmdline-tools..."
        mkdir -p "$ANDROID_SDK_DIR/cmdline-tools"
        cd "$ANDROID_SDK_DIR/cmdline-tools" || exit 1
        wget -q --show-progress "$ANDROID_SDK_URL" -O cmdline-tools.zip
        unzip -q cmdline-tools.zip && rm cmdline-tools.zip
        mv cmdline-tools latest
        echo "✅ Android cmdline-tools instalado"
    else
        echo "ℹ️ Android cmdline-tools já existem"
    fi

    # Pacotes básicos
    echo "==> Instalando pacotes do Android SDK..."
    yes | sdkmanager --install \
        "platform-tools" \
        "platforms;android-35" \
        "build-tools;35.0.0" \
        "emulator" \
        "$AVD_PACKAGE"

    # Licenças
    echo "==> Aceitando licenças..."
    yes | sdkmanager --licenses

    # AVD
    if ! avdmanager list avd | grep -q "$AVD_NAME"; then
        echo "⚠️ Criando AVD '$AVD_NAME'..."
        echo "no" | avdmanager create avd -n "$AVD_NAME" -k "$AVD_PACKAGE" --device "pixel_4" --force
        echo "✅ AVD criado em $AVD_HOME/$AVD_NAME"
    else
        echo "ℹ️ AVD '$AVD_NAME' já existe"
    fi

    flutter doctor
}

start_emulator() {
    setup_env
    echo "==> Verificando se o AVD '$AVD_NAME' existe em $AVD_HOME..."
    if avdmanager list avd | grep -q "$AVD_NAME"; then
        echo "✅ Iniciando emulador $AVD_NAME..."
        nohup emulator -avd "$AVD_NAME" -netdelay none -netspeed full > /dev/null 2>&1 &
        echo "ℹ️ O emulador está iniciando em segundo plano."
        echo "   Use 'adb devices' para verificar."
    else
        echo "❌ AVD '$AVD_NAME' não encontrado! Execute a instalação primeiro."
    fi
}

# =====================================================================
# MENU
# =====================================================================
echo "===================================="
echo " Flutter Manager - 42 (goinfre/$USER)"
echo "===================================="
echo "1) Criar estrutura de pastas"
echo "2) Instalar SDKs (Flutter + Android + Ninja)"
echo "3) Iniciar emulador"
echo "4) Excluir tudo do ambiente"
echo "0) Sair"
echo "===================================="

read -p "Escolha uma opção: " opt
case $opt in
    1) create_folders ;;
    2) install_sdks ;;
    3) start_emulator ;;
    4) clean_all ;;
    0) echo "Saindo..." ;;
    *) echo "❌ Opção inválida" ;;
esac
