require ["include", "variables", "fileinto", "envelope","mailbox"];

if address :matches :domain "from" ["*dpd.de", "*dhl.de", "*hermes.de"] {
    fileinto "Commercial/Delivery";
    stop; 
}
if address :matches "from" ["*for-amusement-only*"] {
    fileinto "Personal/FAO";
    stop; 
}

if address :all :matches "To" "*.*.*@*" {
  set :lower :upperfirst "category" "${1}";
  set :lower :upperfirst "subcat" "${2}";
  set :lower :upperfirst "service" "${3}";

  if mailboxexists "${category}.${subcat}.${service}" {
      fileinto "${category}.${subcat}.${service}";
  } else {
    if mailboxexists "${category}.${subcat}" {
      fileinto "${category}.${subcat}";
    } else {
      if mailboxexists "${category}" {
        fileinto "${category}";
      }
    }
  }
}
else {
  if address :all :matches "To" "*.*@*" {
    set :lower :upperfirst "category" "${1}";
    set :lower :upperfirst "subcat" "${2}";
    
    if mailboxexists "${category}.${subcat}" {
      fileinto "${category}.${subcat}";
    } else {
      if mailboxexists "${category}" {
        fileinto "${category}";
      }
    }
  }
}
