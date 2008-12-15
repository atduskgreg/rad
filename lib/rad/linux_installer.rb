class LinuxInstaller
  
  # this is the thing we actually run to make something happen
  def self.install!
    puts "Welcome to the RAD Linux Installer!"
    puts "-----------------------------------"
    puts "Let's begin."
    puts
    
    check_or_warn_for_usb_driver
    
    # of course we need rubygems
    # maybe just rely on the user installing rubygems, because the ubuntu one sux
    #check_or_install_package("rubygems")
    #%x{gem update --system}
    
    # we need java to make this ship float
    check_or_nag_package("sun-java5-jre")
    
    # remove a package that interferes with the arduino usb/serial driver
    check_or_remove_package("brltty")
    
    # install pre-requisites
    check_or_install_package("binutils-avr")
    check_or_install_package("gcc-avr")
    check_or_install_package("avr-libc")
    check_or_install_package("unzip")
    check_or_install_package("wget")
    
    # remove a probably out of date avrdude
    check_or_remove_package("avrdude")
    
    # install pre-requisites for avrdude if we wanted to build from source
    # nah, it comes with the arduino binary
    #check_or_install_package("gcc")
    #check_or_install_package("bison")
    #check_or_install_package("flex")
    check_or_install_arduino
  end
  
  def self.check_or_install_package(package_name)
  	package = %x{dpkg --get-selections | grep #{package_name}}
  	if package.include?("\tinstall")
  		puts "#{package_name} installed!"
  	else
  		puts "installing #{package_name}..."
  		%x{apt-get install -y #{package_name}}
  	end
  end
  
  def self.check_or_nag_package(package_name, custom_msg = nil)
  	package = %x{dpkg --get-selections | grep #{package_name}}
  	if package.include?("\tinstall")
  		puts "#{package_name} installed!"
  	else
  		puts "you will need to manually install #{package_name}! use the command below."
  		if custom_msg
  			puts custom_msg
  		else
  			puts "sudo apt-get install #{package_name}"
  		end		
  		exit
  	end
  end
  
  def self.check_or_remove_package(package_name)
  	package = %x{dpkg --get-selections | grep #{package_name}}
  
  	#an easier way to check for installed packages?
  	if package.include?("\tinstall")
  		puts "removing #{package_name}..."
  		%x{apt-get remove -y #{package_name}}
  	else
  		puts "#{package_name} previously uninstalled!"
  	end
  end
  
  def self.check_or_warn_for_usb_driver
  
  	# check if usb device recognized by system
  	puts "Please plug in your arduino to your usb port... [hit enter to continue]"
  	STDIN.gets # we patiently wait
  
  	usb = %x{dmesg | tail | grep "FTDI USB Serial" | grep -c "now attached"}
  
  	if usb.to_i == 0
  		# maybe we can be nice here and offer to download and install the driver package
  		puts "the system is not recognizing your usb-serial driver, please re-install"
  		exit
  	end
  end
  
  def self.check_or_install_arduino 
  	if File.exist?("/usr/local/arduino-0012")
  		puts "arduino software previously installed at /usr/local/arduino-0012 !"
  	else
  		puts "installing arduino software..."
  		%x{cd /usr/local/; wget http://arduino.cc/files/arduino-0012-linux.tgz}
  		%x{tar -C /usr/local -xzf /usr/local/arduino-0012-linux.tgz}
  
  		%x{ln -s /usr/local/arduino-0012/arduino ~/Desktop/arduino}
  
  		# gotta patch it so it can run from command line or anywhere
  		arduino_file = File.open("/usr/local/arduino-0012/arduino") {|f| f.read}
  		new_doc = arduino_file.split("\n")
  		new_doc[1] = "cd /usr/local/arduino-0012"
  		File.open("/usr/local/arduino-0012/arduino", "w") {|f| f.puts new_doc }
  
  		%x{mkdir -p /usr/local/arduino-0012/hardware/tools/avr/bin}
  		# there is a difference from what the makefile expects to where it is
  		%x{ln -s /usr/bin/avr-gcc /usr/local/arduino-0012/hardware/tools/avr/bin/avr-gcc}		
  		%x{ln -s /usr/bin/avr-g++ /usr/local/arduino-0012/hardware/tools/avr/bin/avr-g++}
  		%x{ln -s /usr/bin/avr-ar /usr/local/arduino-0012/hardware/tools/avr/bin/avr-ar}
  		%x{ln -s /usr/bin/avr-objcopy /usr/local/arduino-0012/hardware/tools/avr/bin/avr-objcopy}
  		%x{ln -s /usr/local/arduino-0012/hardware/tools/avrdude /usr/local/arduino-0012/hardware/tools/avr/bin/avrdude}
  		%x{ln -s /usr/local/arduino-0012/hardware/tools/avrdude.conf /usr/local/arduino-0012/hardware/tools/avr/etc/avrdude.conf}
  
  
  		puts
  		puts "************************************************************************"
  		puts "**  please add /usr/local/arduino-0012 to your path!                  **"
  		puts "**  you will also need to run sudo update-alternatives --config java  **"
  		puts "**  to choose java-1.50-sun as the default java                       **"
  		puts "************************************************************************"
  		puts
  	end
  	
  end
end



