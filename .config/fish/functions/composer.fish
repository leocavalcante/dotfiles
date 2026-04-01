function composer --description "Composer with auto-loaded auth"
    if not set -q COMPOSER_AUTH; and test -f $COMPOSER_PATH/auth.json
        set -gx COMPOSER_AUTH (cat $COMPOSER_PATH/auth.json)
    end
    command composer $argv
end
