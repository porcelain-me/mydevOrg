trigger AccountAddressTrigger on Account (before insert,before update) {
 system.debug('helloooooo');   
}