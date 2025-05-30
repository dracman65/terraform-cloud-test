terraform { 
  cloud { 
    
    organization = "smoker65" 

    workspaces { 
      name = "tfworkflowplan01" 
    } 
  } 
}