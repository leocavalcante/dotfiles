function up --description "System update utility"
    switch (uname)
        case Linux
            if set -q TERMUX_VERSION
                pkg update; and pkg upgrade -y
            else
                sudo apt update; and sudo apt upgrade -y; and sudo apt autoremove -y
            end
    end

    if command -q brew
        brew update; and brew upgrade; and brew cleanup
    end
end
