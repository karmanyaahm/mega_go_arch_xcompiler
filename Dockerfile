FROM archlinux:base-20211219.0.41944

# prepare for building
RUN echo 'ParallelDownloads=5' >> /etc/pacman.conf && \
	useradd -m -s /bin/sh builder && \
        pacman -Syu sudo --noconfirm --needed && \
        echo 'builder ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
        chmod ugo+rwx . && \
	yes | pacman -Scc


RUN pacman -Syu --needed --noconfirm git base-devel && \
	 yes | pacman -Scc

USER builder
RUN cd ~ && \
                git clone https://aur.archlinux.org/yay-bin.git && \
                cd yay-bin && \
                makepkg -si --noconfirm && \
		cd ~; rm -rf yay-bin

RUN yay --noconfirm --needed -S aarch64-linux-gnu-gcc musl aarch64-linux-musl lib32-glibc lib32-gcc-libs go && \
	yes | sudo pacman -Scc && yes | yay -Scc && yes | yay -c

COPY build /usr/local/bin/build

WORKDIR /app
