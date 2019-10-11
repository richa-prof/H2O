function check_credit_card_number(credit_card_number) {

  var visa = /^(?:4[0-9]{12}(?:[0-9]{3})?)$/;
  var mastercard = /^(?:5[1-5][0-9]{14})$/;
  var amex = /^(?:3[47][0-9]{13})$/;

  var credit_card_brand = false;

  if (visa.test(credit_card_number)) {
    credit_card_brand = 'Visa';
  } else if(mastercard.test(credit_card_number)) {
    credit_card_brand = 'Master';
  } else if(amex.test(credit_card_number)) {
    credit_card_brand = 'Amex';
  }

  return(credit_card_brand);
}
