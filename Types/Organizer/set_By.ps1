$this | Add-Member NoteProperty '#by' $args -Force
$this.PSObject.properties.Remove('#organized')