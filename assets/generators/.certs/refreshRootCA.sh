openssl req -x509 -nodes -new -sha256 -days 398 -newkey rsa:2048 -keyout RootCA.key -out RootCA.pem -config root.csr.cnf
openssl x509 -outform pem -in RootCA.pem -out RootCA.crt
