sudo pacman -S git sbsigntools
git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -sci
cd ..
yay -S shim-signed
sudo mv /boot/EFI/BOOT/BOOTx64.EFI /boot/EFI/BOOT/grubx64.efi
sudo cp /usr/share/shim-signed/shimx64.efi /boot/EFI/BOOT/BOOTx64.EFI
sudo cp /usr/share/shim-signed/mmx64.efi /boot/EFI/BOOT/
sudo openssl req -newkey rsa:2048 -nodes -keyout MOK.key -new -x509 -sha256 -days 3650 -subj "/CN=my Machine Owner Key/" -out MOK.crt
sudo openssl x509 -outform DER -in MOK.crt -out MOK.cer
sudo sbsign --key MOK.key --cert MOK.crt --output /boot/vmlinuz-linux /boot/vmlinuz-linux
sudo sbsign --key MOK.key --cert MOK.crt --output /boot/EFI/BOOT/grubx64.efi /boot/EFI/BOOT/grubx64.efi
sudo cp MOK.cer /boot/EFI/
sudo cp MOK.key /
sudo cp MOK.crt /
sudo grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --modules="all_video boot btrfs cat chain configfile echo efifwsetup efinet ext2 fat font gettext gfxmenu gfxterm gfxterm_background gzio halt help hfsplus iso9660 jpeg keystatus loadenv loopback linux ls lsefi lsefimmap lsefisystab lssal memdisk minicmd normal ntfs part_apple part_msdos part_gpt password_pbkdf2 png probe reboot regexp search search_fs_uuid search_fs_file search_label sleep smbios squash4 test true video xfs zfs zfscrypt zfsinfo play cpuid cryptodisk luks tpm" --disable-shim-lock --sbat /usr/share/grub/sbat.csv
sudo sbsign --key MOK.key --cert MOK.crt --output /boot/EFI/GRUB/grubx64.efi /boot/EFI/GRUB/grubx64.efi
sudo cp /boot/EFI/GRUB/grubx64.efi /boot/EFI/BOOT/grubx64.efi
sudo cp kernel /etc/initpio/post/kernel-sbsign
sudo chmod +x /etc/initpio/post/kernel-sbsign
