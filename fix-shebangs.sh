#!/bin/bash
# Script to add shebangs to shell scripts that are missing them

echo "Adding shebangs to shell scripts..."

# Find all .sh files without shebangs and add them
find install -name "*.sh" -exec sh -c '
    file="$1"
    if ! head -1 "$file" | grep -q "^#!/"; then
        echo "Adding shebang to: $file"
        # Create temporary file with shebang + original content
        { echo "#!/bin/bash"; cat "$file"; } > "$file.tmp"
        mv "$file.tmp" "$file"
    fi
' _ {} \;

echo "Done adding shebangs."