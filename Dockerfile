FROM solidnerd/bookstack:0.20.3

ENV DB_HOST=devops-bookstackdb
ENV DB_DATABASE=bookstack
ENV DB_USERNAME=admin
ENV DB_PASSWORD=zaq12wsx

ENV AUTH_METHOD=ldap

ENV LDAP_SERVER=devops-ldap
ENV LDAP_BASE_DN=dc=ibm,dc=com
ENV LDAP_DN=cn=admin,dc=ibm,dc=com
ENV LDAP_PASS=zaq12wsx
ENV LDAP_USER_FILTER=(&(uid=\$\{user\}))
ENV LDAP_VERSION=3
ENV LDAP_EMAIL_ATTRIBUTE=mail
