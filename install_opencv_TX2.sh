BASEDIR="$(pwd)"

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y build-essential

sudo apt-get install -y curl libssl-dev
sudo apt-get install -y ffmpeg

#
sudo apt-get install -y libopenblas-dev liboplenblas-base liblapacke-dev 
sudo apt-get install -y libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev

#From opencv documentation
sudo apt-get install -y build-essential
sudo apt-get install -y cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get install -y python-dev python3-dev libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev libboost-all-dev

sudo apt-get install -y libgoogle-glob-dev
sudo apt-get install -y libgflags-dev
sudo apt-get install -y protobuf-compiler libprotobuf-dev

#I recommand install numpy via pip
sudo apt-get install -y  python-dev python3-dev python3-pip
python3 -m pip install numpy scipy
sudo apt-get remove -y python2.7-minimal

#install Eigen 
sudo apt-get remove -y libeigen3-dev
cd  $HOME/Downloads
wget -O eigen.zip https://gitlab.com/libeigen/eigen/-/archive/3.3.7/eigen-3.3.7.zip
unzip eigen.zip
mkdir eigen-build && eigen-build 
mkdir ../eigen-3.3.7/ && sudo make install

OPENCV_VERSION="4.4.0"
cd /opt && \
git clone --depth 1 --branch ${OPENCV_VERSION} https://github.com/opencv/opencv.git && \
git clone --depth 1 --branch ${OPENCV_VERSION} https://github.com/opencv/opencv_contrib.git && \
cd /opt/opencv/cmake && \
sudo rm FindCUDNN.cmake && \
sudo cp $BASEDIR/FindCUDNN.cmake /opt/opencv/cmake && \
cd /opt/opencv && \
mkdir build && \
cd build && \
cmake \
    -D CMAKE_CXX_COMPILER=/usr/bin/g++ \
    -D CMAKE_C_COMPILER=/usr/bin/gcc \
    -D BUILD_NEW_PYTHON_SUPPORT=ON \
    -D CPACK_BINARY_DEB=ON \
    -D BUILD_EXAMPLES=ON \
    -D BUILD_opencv_python3=ON \
    -D INSTALL_C_EXAMPLES=ON  \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D BUILD_opencv_java=OFF \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D CUDA_ARCH_BIN=6.2,7.5 \
    -D CUDA_ARCH_PTX= \
    -D CUDA_FAST_MATH=ON \
    -D CUDNN_INCLUDE_DIR=/usr/include \
    -D EIGEN_INCLUDE_PATH=/usr/include/eigen3 \
    -D WITH_EIGEN=ON \
    -D ENABLE_NEON=ON \
    -D OPENCV_DNN_CUDA=ON \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D WITH_CUBLAS=ON \
    -D WITH_CUDA=ON \
    -D WITH_CUDNN=ON \
    -D WITH_GSTREAMER=ON \
    -D WITH_LIBV4L=ON \
    -D WITH_NVCUVID=ON \
    -D WITH_OPENGL=ON \
    -D WITH_OPENCL=OFF \
    -D WITH_IPP=OFF \
    -D_WITH_QT=ON \
    -D WITH_TBB=ON \
    -D BUILD_TIFF=ON \
    -D BUILD_PERF_TESTS=OFF \
    -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
    -D BUILD_TESTS=OFF \
    .. 
#5.3,6.2,7.2,8.7 
cd /opt/opencv/build && sudo make -j$(nproc)
cd /opt/opencv/build && sudo make install
#cd /opt/opencv/build && make package
#cd /opt/opencv/build && tar -czvf OpenCV-${OPENCV_VERSION}-aarch64.tar.gz *.deb
