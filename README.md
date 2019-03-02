adjust cpu cores for compile, build and push images
```
REPO=pwfoo
for IMG in $(ls -1 packages/); do echo $IMG; docker build --build-arg NUM_JOBS=4 -t $REPO/mcl-$IMG packages/$IMG/ && docker push $REPO/mcl-$IMG; done
```

generate output with linuxkit
```
FORMAT="-format kernel+initrd -format raw-efi"	# raw-efi -> dd to usb stick
OUTDIR=out
mkdir -p $OUTDIR
docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):$(which docker) -v $(pwd):$(pwd) --workdir $(pwd) pwfoo/linuxkit build $FORMAT -name mcl -dir $OUTDIR mcl.yml
```

run with qemu / kvm
```
sudo qemu-system-x86_64 -m 512M -enable-kvm -kernel out/mcl-kernel -initrd out/mcl-initrd.img -nographic -device pvpanic -append 'console=ttyAMA0,115200 console=tty highres=off console=ttyS0'
```

additional qemu examples
```
sudo qemu-system-x86_64 -m 512M -enable-kvm -kernel out/mcl-kernel -initrd out/mcl-initrd.img -nographic -device pvpanic -append 'console=ttyAMA0,115200 console=tty highres=off console=ttyS0 random.trust_cpu=on'
sudo qemu-system-x86_64 -m 512M -enable-kvm -kernel out/mcl-kernel -initrd out/mcl-initrd.img -nographic -device pvpanic -append 'console=ttyAMA0,115200 console=tty highres=off console=ttyS0 random.trust_cpu=on ip=dhcp'
```
