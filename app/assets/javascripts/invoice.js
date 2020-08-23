$(document).on("click", "#refund", function() {
  console.log("click");
  var invoice_id = $(this).data("id");

  $.post("/refunds", {invoice_id: invoice_id});
});


$(document).on("click", "#re_payment", function(e) {
  var invoice_id = $(this).data("id");
  var product_id = $(this).data("product-id");
  var price = $(this).data("price");

  handler = stripe_checkout_function(product_id, invoice_id, PAYMENT_PATH);
  handler.open({
    name: "Stripe Demo",
    description: "Demo payment",
    amount: price
  });
  e.preventDefault();
});

function stripe_checkout_function(product_id, invoice_id, path) {
  var handler = StripeCheckout.configure({
    key: STRIPE_KEY,
    //image: '/img/documentation/checkout/marketplace.png',
    locale: "auto",
    token: function (token) {
      $.ajax({
        method: "POST",
        beforeSend: function (xhr) {
          xhr.setRequestHeader("X-CSRF-Token", $("meta[name='csrf-token']").attr("content"));
        },
        url: path,
        data: {
          token: token.id,
          product_id: product_id,
          invoice_id: invoice_id
        }
      });
    }
  });

  return handler;
}

$(window).on("popstate", function () {
  handler.close();
});

$(document).on("click", "#stripe-credit-button-subscription", function(e) {
  var plan_id = $(this).data("id");
  var price = $(this).data("price");
  var name = $(this).data("name");

  var handler = StripeCheckout.configure({
    key: STRIPE_KEY,
    //image: '/img/documentation/checkout/marketplace.png',
    locale: "auto",
    token: function (token) {
      $.ajax({
        method: "POST",
        beforeSend: function (xhr) {
          xhr.setRequestHeader("X-CSRF-Token", $("meta[name='csrf-token']").attr("content"));
        },
        url: SUBSCRIPTION_PATH,
        data: {
          token: token.id,
          plan_id: plan_id
        }
      });
    }
  });

  handler.open({
    name: "Stripe Demo",
    description: name,
    amount: price * 100
  });
  e.preventDefault();

});
