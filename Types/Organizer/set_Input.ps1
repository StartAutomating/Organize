$this | Add-Member NoteProperty '#input' $args -Force
$this.PSObject.properties.Remove('#organized')