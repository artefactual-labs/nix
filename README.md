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
    ffmpeg version 5.1.3 Copyright (c) 2000-2022 the FFmpeg developers
    built with gcc 13.2.0 (GCC)
    configuration: --disable-static --prefix=/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-ffmpeg-headless-5.1.3 --target_os=linux --arch=x86_64 --pkg-config=pkg-config --enable-gpl --enable-version3 --disable-nonfree --disable-static --enable-shared --enable-pic --disable-thumb --disable-small --enable-runtime-cpudetect --disable-gray --enable-swscale-alpha --enable-hardcoded-tables --enable-safe-bitstream-reader --enable-pthreads --disable-w32threads --disable-os2threads --enable-network --enable-pixelutils --datadir=/nix/store/mxbd3nxibx8yafvjk061k5mhpndfwfqb-ffmpeg-headless-5.1.3-data/share/ffmpeg --enable-ffmpeg --disable-ffplay --enable-ffprobe --bindir=/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-ffmpeg-headless-5.1.3-bin/bin --enable-avcodec --enable-avdevice --enable-avfilter --enable-avformat --enable-avutil --enable-postproc --enable-swresample --enable-swscale --libdir=/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-ffmpeg-headless-5.1.3-lib/lib --incdir=/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-ffmpeg-headless-5.1.3-dev/include --enable-doc --enable-htmlpages --enable-manpages --mandir=/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-ffmpeg-headless-5.1.3-man/share/man --enable-podpages --enable-txtpages --docdir=/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-ffmpeg-headless-5.1.3-doc/share/doc/ffmpeg --enable-alsa --disable-libaom --enable-libass --disable-libbluray --disable-libbs2b --enable-bzlib --disable-libcelt --disable-chromaprint --disable-cuda --disable-cuda-llvm --enable-libdav1d --disable-libdc1394 --enable-libdrm --disable-libfdk-aac --disable-libflite --enable-fontconfig --enable-libfreetype --disable-frei0r --disable-libfribidi --disable-libgme --enable-gnutls --disable-libgsm --enable-iconv --disable-libjack --disable-ladspa --enable-lzma --disable-libmfx --disable-libmodplug --enable-libmp3lame --disable-libmysofa --enable-cuvid --enable-nvdec --enable-nvenc --disable-openal --disable-opencl --disable-libopencore-amrnb --disable-opengl --disable-libopenh264 --disable-libopenjpeg --disable-libopenmpt --enable-libopus --disable-libplacebo --disable-libpulse --disable-librav1e --disable-librtmp --disable-libsmbclient --disable-sdl2 --disable-libshaderc --enable-libsoxr --enable-libspeex --enable-libsrt --enable-libssh --disable-librsvg --enable-libsvtav1 --disable-libtensorflow --enable-libtheora --enable-libv4l2 --enable-v4l2-m2m --enable-vaapi --disable-vdpau --disable-libvidstab --disable-libvmaf --disable-libvo-amrwbenc --enable-libvorbis --enable-libvpx --disable-vulkan --disable-libwebp --enable-libx264 --enable-libx265 --disable-libxavs --disable-libxcb --disable-libxcb-shape --disable-libxcb-shm --disable-libxcb-xfixes --disable-xlib --disable-libxml2 --enable-libxvid --enable-libzimg --enable-zlib --disable-libzmq --disable-debug --enable-optimizations --disable-extra-warnings --disable-stripping
    libavutil      57. 28.100 / 57. 28.100
    libavcodec     59. 37.100 / 59. 37.100
    libavformat    59. 27.100 / 59. 27.100
    libavdevice    59.  7.100 / 59.  7.100
    libavfilter     8. 44.100 /  8. 44.100
    libswscale      6.  7.100 /  6.  7.100
    libswresample   4.  7.100 /  4.  7.100
    libpostproc    56.  6.100 / 56.  6.100

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
    /nix/store/g2rr4c7c7968jggzzzh558hlhab1b8pj-ffmpeg-headless-5.1.3-bin/bin/ffmpeg
