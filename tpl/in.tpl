Hi {{ key "user" }} !!!

Here is a list of the consul servers you just started! 
{{ range service "consul" }}
server {{ .Name }} {{ .Address }}:{{ .Port }}{{ end }}
