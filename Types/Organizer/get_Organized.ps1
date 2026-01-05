if ($this.'#Organized') {
    return $this.'#Organized'
}

# First, collect all of the input and arguments.
$allIn = @($this.Input)    
$allArgs = @($this.By)
$join = $this.Join
$flat = $this.Flat

# What we will do is determine all of the valid keys for an input,
# ensure a hierarchy exists for all keys, and store whatever objects we find.

# To make all of this easy on indentation, we will make a filter to expand our keys
filter getKeys {
    $in = $_

    # it will walk over each argument
    foreach ($arg in $args) {
        # if the argument exists in the input
        if ($null -ne $in.$arg) {
            $in.$arg # that's our key
            continue
        }

        # If the input is dictionary-like and the value exists in the dictionary
        if ($in.item -and 
            $null -ne $in[$arg]
        ) {
            # That's our key
            $in[$arg]
            continue
        }

        # If the argument is a scriptblock
        if ($arg -is [ScriptBlock]) {
            # pipe in our input and run it
            $in | . $arg
            continue # and that is our key
        }
        
        # Now for the syntax magic hard part:
        # We want to be able to dot into properties, for example `Directory.Name`
        # So we split our argument up by dots
        $dotSequence = @($arg -split '\.')
        $pointer = $in                                    
        :dotLoop for (
            $dotNumber = 0;
            $dotNumber -lt $dotSequence.Count;
            $dotNumber++
        ) {
            # If we are the last dot in the sequence, we want 
            $lastDot = ($dotNumber + 1) -eq $dotSequence.Count
            # and we also want to be able to create hierarchies from multiple properties
            # For example `LastWriteTime.Year/Month/Date`.
            
            # So we split the dot sequence by slashes
            foreach ($key in $dotSequence[$dotNumber] -split '[\\/]') {
                # If the key exists
                if ($pointer.$key) {
                    # and we are the last dot
                    if ($lastDot) {
                        $pointer.$key # output the key
                    } else {
                        $pointer = $pointer.$key # otherwise, move the pointer.
                    }                        
                }
                # And do the exact same thing for any dictionary-like object.
                elseif ($pointer.item -and $pointer[$key]) {
                    if ($lastDot) {
                        $pointer[$key]
                    } else {
                        $pointer = $pointer[$key]
                    }
                } else {
                    # if the key does not exist, 
                    # we don't want to keep dotting into nothing
                    # so we break out of the dotloop
                    break dotLoop
                }                    
            }                
        }
    }
}

# Now that we can expand the keys, it's time to get organized.
$organized = [Ordered]@{}
# Walk over each input
:nextInput foreach ($in in $allIn) {
    # key the keys for that input.
    $keys = @($in | getKeys @allArgs)
    # If there were no keys, continue to the next input.
    if (-not $keys) { continue nextInput }
    
    if ($flat -or $join) {
        $keys = @($keys -join $(
            if ($join) { $join }
            else { '/' }
        ))
    }

    # Now we need to make sure our hierarchy exists.
    $pointer = $organized

    # Go over each key
    for ($keyNumber = 0 ;$keyNumber -lt ($keys.Count - 1); $keyNumber++) {            
        $key = $keys[$keyNumber]
        # (stringify any integer keys so that we can put them in an [Ordered] dictionary)
        if ($key -is [int]) {                
            $key = "$key"
        }
    
        # If the key does not exist at the pointer
        if (-not $pointer[$key]) {
            # make the key
            $pointer[$key] = [Ordered]@{}
        }

        # If the pointer is was not a dictionary, 
        # things have already been organized into a bucket.
        if ($pointer[$key] -isnot [Collections.IDictionary]) {
            # so break out.
            break
        }
        # Otherwise, set the pointer to the key
        # and continue the loop.
        $pointer = $pointer[$key]                        
    }

    # Once we've made the hierarchy,
    # Get the last key (or wherever we broke out of the loop)
    $key = $keys[$keyNumber]
    if ($key -is [int]) {
        $key = "$key"
    }
    # If the key does not exist
    if ($null -eq $pointer[$key]) {
        # create one
        $pointer[$key] = $in
    } else {
        # otheriwse, make it a bucket and add the next item.
        $pointer[$key] = @($pointer[$key]) + @($in)
    }
}


# Now we should be organized!
$this | Add-Member NoteProperty '#Organized' $organized -Force 
return $organized