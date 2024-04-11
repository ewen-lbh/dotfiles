function proxy7
echo Establishing a SOCKS v5 proxy on 0.0.0.0:1080
 ssh -N -D 0.0.0.0:1080 -q -C -N root@titan.inpt.fr; 
end
