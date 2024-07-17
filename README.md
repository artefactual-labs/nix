## Usage

Install Nix on your system:

    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

Check out the repository:

    git clone https://github.com/sevein/run

Show the outputs provided by the flake:

    $ nix flake show
    git+file:///home/jesus/Projects/run
    ├───apps
    │   └───x86_64-linux
    │       ├───ffmpeg: app
    │       └───magick: app
    ├───devShells
    │   └───x86_64-linux
    │       └───default: development environment 'nix-shell'
    └───packages
        └───x86_64-linux
            ├───ffmpeg: package 'ffmpeg-headless-7.0.1'
            └───imagemagick: package 'imagemagick-7.1.1-34'

Run ffmpeg:

    $ nix run .#ffmpeg -- -version
    ffmpeg version 7.0.1 Copyright (c) 2000-2024 the FFmpeg developers
    built with gcc 13.3.0 (GCC)
    configuration: --disable-static --prefix=/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-ffmpeg-headless-7.0.1 --target_os=linux --arch=x86_64 --pkg-config=pkg-config --enable-gpl --enable-version3 --disable-nonfree --disable-static --enable-shared --enable-pic --disable-thumb --disable-small --enable-runtime-cpudetect --disable-gray --enable-swscale-alpha --enable-hardcoded-tables --enable-safe-bitstream-reader --enable-pthreads --disable-w32threads --disable-os2threads --enable-network --enable-pixelutils --datadir=/nix/store/rwjbkvahlavmx6vbj5mgcbwg22gcx81p-ffmpeg-headless-7.0.1-data/share/ffmpeg --enable-ffmpeg --disable-ffplay --enable-ffprobe --bindir=/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-ffmpeg-headless-7.0.1-bin/bin --enable-avcodec --enable-avdevice --enable-avfilter --enable-avformat --enable-avutil --enable-postproc --enable-swresample --enable-swscale --libdir=/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-ffmpeg-headless-7.0.1-lib/lib --incdir=/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-ffmpeg-headless-7.0.1-dev/include --enable-doc --enable-htmlpages --enable-manpages --mandir=/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-ffmpeg-headless-7.0.1-man/share/man --enable-podpages --enable-txtpages --docdir=/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-ffmpeg-headless-7.0.1-doc/share/doc/ffmpeg --enable-alsa --disable-libaom --disable-appkit --disable-libaribcaption --enable-libass --disable-audiotoolbox --disable-avfoundation --disable-avisynth --disable-libbluray --disable-libbs2b --enable-bzlib --disable-libcaca --disable-libcelt --disable-chromaprint --disable-libcodec2 --disable-coreimage --disable-cuda --disable-cuda-llvm --enable-cuvid --enable-libdav1d --disable-libdc1394 --enable-libdrm --disable-libdvdnav --disable-libdvdread --disable-libfdk-aac --enable-ffnvcodec --disable-libflite --enable-fontconfig --enable-libfontconfig --enable-libfreetype --disable-frei0r --disable-libfribidi --disable-libgme --enable-gnutls --disable-libgsm --enable-libharfbuzz --enable-iconv --disable-libjack --disable-libjxl --disable-ladspa --enable-lzma --disable-metal --disable-libmfx --disable-libmodplug --enable-libmp3lame --disable-libmysofa --enable-nvdec --enable-nvenc --disable-openal --disable-opencl --disable-libopencore-amrnb --disable-libopencore-amrwb --disable-opengl --disable-libopenh264 --disable-libopenjpeg --disable-libopenmpt --enable-libopus --disable-libplacebo --disable-libpulse --disable-libqrencode --disable-libquirc --disable-librav1e --disable-librtmp --disable-libsmbclient --disable-sdl2 --disable-libshaderc --enable-libsoxr --enable-libspeex --enable-libsrt --enable-libssh --disable-librsvg --enable-libsvtav1 --disable-libtensorflow --enable-libtheora --disable-libtwolame --enable-libv4l2 --enable-v4l2-m2m --enable-vaapi --disable-vdpau --disable-libvpl --disable-videotoolbox --disable-libvidstab --disable-libvmaf --disable-libvo-amrwbenc --enable-libvorbis --enable-libvpx --disable-vulkan --disable-libwebp --enable-libx264 --enable-libx265 --disable-libxavs --disable-libxcb --disable-libxcb-shape --disable-libxcb-shm --disable-libxcb-xfixes --disable-libxevd --disable-libxeve --disable-xlib --disable-libxml2 --enable-libxvid --enable-libzimg --enable-zlib --disable-libzmq --disable-debug --enable-optimizations --disable-extra-warnings --disable-stripping
    libavutil      59.  8.100 / 59.  8.100
    libavcodec     61.  3.100 / 61.  3.100
    libavformat    61.  1.100 / 61.  1.100
    libavdevice    61.  1.100 / 61.  1.100
    libavfilter    10.  1.100 / 10.  1.100
    libswscale      8.  1.100 /  8.  1.100
    libswresample   5.  1.100 /  5.  1.100
    libpostproc    58.  1.100 / 58.  1.100

Run magick:

    $ nix run .#magick -- -version
    Version: ImageMagick 7.1.1-34 Q16-HDRI x86_64 39a4f1cb2:20240623 https://imagemagick.org
    Copyright: (C) 1999 ImageMagick Studio LLC
    License: https://imagemagick.org/script/license.php
    Features: Cipher DPC HDRI OpenMP(4.5)
    Delegates (built-in): bzlib cairo djvu fontconfig freetype heic jng jp2 jpeg jxl lcms lqr lzma openexr pangocairo png raw rsvg tiff webp x xml zlib zstd
    Compiler: gcc (13.3)

Run a Bash shell with the build environment:

    $ nix develop
    (nix:nix-shell-env) $ which ffmpeg
    /nix/store/pdgsm9syw7nmcs8l1nzvzfy5n5vrhi94-ffmpeg-headless-7.0.1-bin/bin/ffmpeg
