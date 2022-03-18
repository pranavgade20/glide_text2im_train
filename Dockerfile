FROM pytorchlightning/pytorch_lightning:base-cuda-py3.9-torch1.10

RUN apt-get update && apt-get install -y openssh-server sudo

# setting up ssh server - i dunno which parts are necessary, but this seems to work after a lot of pain
RUN mkdir -p /var/run/sshd \
  && touch /root/.Xauthority \
  && true
RUN printf 'PasswordAuthentication no \nPermitRootLogin without-password \nPubkeyAuthentication yes \nStrictModes no' >> /etc/ssh/sshd_config

# create server keys, you might need to remove previous keys from ~/.ssh/known_kosts on the client
RUN ssh-keygen -A
# adding my publickey to the server
RUN mkdir /root/.ssh && echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDnEEJpur29Jd+++jBSLRUQ5Xoj2/ye4Pz2xcllrVeod1f7mT2rePHYItsCzEYQCA9CNfn+qsnox1Kw1pQi5QyPPOoXUrmM+b4t17V6mOtBI7PWfQn+b+HyU/AY5y5rioniMEmKghHhENDu6xU4GYs0+OPU+N0UO8rz4KPItXbNxp+Gxw7H9u+tvZFqCfraKJ28i4/ySy25un3HhR7BmAIHamfqugIkuQ8F3cmYz93cGSN75YWO385cb+WcIs+kMLNyLzpTKVkGyUy7YnO71kJMcuAku7bw/1alMtJxVNI+nwDWOKAgtFQWTux5EyWgddh2XhYBmdWgKr7pSDYF6HqBT6hosUcMVvAwFkWeXlXuAcVzBc3/LtqPeGPgoFS5t7m6DLUXsIH5/Bc+vnoyEc/Rn3V1sHCgjueI48kmh9rhF3BAk7NWJj2yWCLKhgarucHkLxzaRTiKA/IHXSZID3Vs82MnyNqcTeakZcZQQ5JTyxkrxpTgE2L0Bj9Ssifngs0= p@claret" > /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys
# alpine ssh doesn't work unless root has a password??
RUN echo 'root:dummy_passwd'|chpasswd
# expose ssh port 
EXPOSE 22
# run ssh server
CMD /usr/sbin/sshd -D




