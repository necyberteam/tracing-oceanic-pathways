FROM debian:jessie-slim
USER root
RUN apt-get -m update && \
	apt-get install -y --no-install-recommends libpolylib64-dev libtool-bin ctags cproto ed gfortran gnuplot ipython libmpfr-dev libncurses5 libpython2.7 libreadline5 python python-ply autoconf automake bison indent flex gnulib libgmp3-dev libncurses5-dev libreadline6-dev libtool python-dev subversion swig wget mpc gmp-ecm pkg-config unzip
WORKDIR /home/ltrans/
ADD https://s3.amazonaws.com/hdf-wordpress-1/wp-content/uploads/manual/HDF5/HDF5_1_10_5/source/hdf5-1.10.5.tar.gz hdf5-1.10.5.tar.gz
ADD https://curl.haxx.se/download/curl-7.65.1.tar.gz curl-7.65.1.tar.gz
ADD https://zlib.net/zlib-1.2.11.tar.gz zlib-1.2.11.tar.gz
ADD https://codeload.github.com/Unidata/netcdf-c/tar.gz/v4.6.2 v4.6.2.tar.gz
ADD https://codeload.github.com/Unidata/netcdf-fortran/tar.gz/v4.4.5 v4.4.5.tar.gz
ADD https://github.com/necyberteam/tracing-oceanic-pathways/raw/master/LTRANSv2b.zip LTRANSv2b.zip
ENV H5DIR /usr/local 
ENV ZDIR /usr/local
ENV NCDIR /home/ltrans/local
RUN tar -zxf hdf5-1.10.5.tar.gz && \
	tar -zxf curl-7.65.1.tar.gz && \
	tar -zxf zlib-1.2.11.tar.gz && \
	tar -zxf v4.6.2.tar.gz && \
	tar -zxf v4.4.5.tar.gz && \
	unzip LTRANSv2b.zip && \
	rm hdf5-1.10.5.tar.gz && \
	rm curl-7.65.1.tar.gz && \
	rm zlib-1.2.11.tar.gz && \
	rm v4.6.2.tar.gz && \
	rm v4.4.5.tar.gz && \
	rm LTRANSv2b.zip && \
	cd zlib-1.2.11 && \
	./configure --prefix=${ZDIR} && \
	make && \
	make install && \
	cd .. && \
	cd hdf5-1.10.5 && \
	./configure --with-zlib=${ZDIR} --prefix=${H5DIR} --enable-hl && \
	make && \
	make install && \
	cd .. && \
	cd curl-7.65.1 && \
	./configure && \
	make && \
	make install && \
	export LD_LIBRARY_PATH=/usr/local:/usr/local/lib:$LD_LIBRARY_PATH && \
	cd .. && \
	cd netcdf-c-4.6.2 && \
	CPPFLAGS='-I${H5DIR}/include -I${ZDIR}/include' LDFLAGS='-L${H5DIR}/lib -L${ZDIR}/lib' ./configure --prefix=${NCDIR} && \
	make && \
	make install && \
	export LD_LIBRARY_PATH=/home/ltrans/local/lib:$LD_LIBRARY_PATH && \
	cd .. && \
	cd netcdf-fortran-4.4.5 && \
	CPPFLAGS=-I${NCDIR}/include LDFLAGS=-L${NCDIR}/lib ./configure --prefix=${NCDIR} && \
	make && \
	make install && \
	cd /home/ltrans/ && \
	cp ./netcdf-fortran-4.4.5/fortran/netcdf.inc /home/ltrans/LTRANSv2b && \
	cp ./netcdf-fortran-4.4.5/fortran/netcdf.mod /home/ltrans/LTRANSv2b
ENV LD_LIBRARY_PATH /home/ltrans/local/lib:/usr/local/lib