[Unit]
Description= Boomi Atom
RequiresMountsFor=/home/boomi
Wants=network-online.target
After=network.target network-online.target
[Service]
Type=forking
Restart=always
User=boomi
ExecStart=/bin/sh -c "/home/boomi/Boomi_AtomSphere/Atom/<your_atom_name>/bin/atom start"
ExecStop=/bin/sh -c "/home/boomi/Boomi_AtomSphere/Atom/<your_atom_name>/bin/atom stop"
ExecReload=/bin/sh -c "/home/boomi/Boomi_AtomSphere/Atom/<your_atom_name>/bin/atom restart"
[Install]
WantedBy=multi-user.target
