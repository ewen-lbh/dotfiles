function proxy7
echo Establishing a SOCKS v5 proxy on 0.0.0.0:8888
 ssh -N -D 0.0.0.0:8888 -q -C -N root@titan.inpt.fr; 
end
