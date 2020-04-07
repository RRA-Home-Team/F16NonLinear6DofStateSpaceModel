%works out the aerodynamic y-axis (side force) coefficient 

function [output] = CY(BETA,AIL,RDR)

output=-0.02.*BETA+0.21.*(AIL./20.0)+0.086.*(RDR./30.0);