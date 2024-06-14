- name: SG Rules
  sg:
  - expense-dev-db
  - expense-dev-backend
  - expense-dev-frontend
  - expense-dev-bastion
  - expense-dev-vpn
  - expense-dev-app_alb
  expense-dev-vpn:
  - name: vpn_public
    desc: vpn acceping connections from public
    source: public
    port: 943, 443, 22, 1194
  
  db:
  - name: db_backend
    desc: db accepting connections from backend
    source: backend
    port: 3306
  - name: db_bastion
    desc: db accepting connections from bastion
    source: bastion
    port: 3306
  - name: db_vpn
    desc: db accepting connections from vpn
    source: vpn
    port: 3306  
  app_alb:
  - name: app_alb-vpn
    desc: vpn acceping connections from vpn 
    source: vpn
    port: 80   
  backend:
  - name: backend_app_alb
    desc: backend accepting connections from app-alb
    source: app-alb
    port: 8080 
  - name: backend_bastion
    desc: backend accepting connections from bastion
    source: bastion
    port: 22
  - name: backend_vpn_ssh
    desc: backend accepting connections from vpn-ssh
    source: vpn-ssh
    port: 22   
  - name: backend_vpn_http
    desc: backend accepting connections from vpn-http
    source: vpn-http
    port: 8080
  frontend:
  - name: frontend_public
    desc: frontend accepting connections from public
    source: public
    port: 80
  - name: frontend_bastion
    desc: frontend accepting connections from bastion
    source: bastion
    port: 22
  
  bastion:
  - name: bastion_public
    desc: bastion accepting connections from public
    source: public #idealy your home IP address/32
    port: 22
  