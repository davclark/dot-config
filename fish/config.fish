source /opt/homebrew/opt/asdf/libexec/asdf.fish

if status is-interactive
    # Commands to run in interactive sessions can go here
    ssh-add --apple-load-keychain
    starship init fish | source
end
