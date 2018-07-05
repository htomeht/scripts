# EZDOCK

This is a very simple docking helper.
It is installed by placing the rules file in
/etc/udev/rules.d and the perl script in /var/lib64/udev.
The ezdock.ini should be placed in ~/.config/

1. sudo cp 98-ezdock.rules /etc/udev/rules.d
2. sudo cp ezdock.pl /lib64/udev
3. cp ezdock.ini ~/.config
4. sudo udevadm control --reload-rules
