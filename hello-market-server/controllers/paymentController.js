
const stripe = require('stripe')('sk_test_51Ai2s8HlHcPNi5kGS9cdIXZd4VEbZo2zQmZGU4vi6oEVRW9K5WKio6JeeRwjClNHakQhd3Rv60TxLGiMZrrcpQMk00pxsVbJSz');

exports.createPaymentIntent = async (req, res) => {

  // totalAmount is in dollars 
  const { totalAmount } = req.body

  // Ensure totalAmount is a valid number
  if (typeof totalAmount !== "number" || isNaN(totalAmount)) {
    return res.status(400).json({ error: "Invalid totalAmount" });
  }

  // Convert dollars to cents
  const totalAmountInCents = Math.round(totalAmount * 100);

  // Use an existing Customer ID if this is a returning customer.
  const customer = await stripe.customers.create();
  const ephemeralKey = await stripe.ephemeralKeys.create(
    { customer: customer.id },
    { apiVersion: '2017-06-05' }
  );
  const paymentIntent = await stripe.paymentIntents.create({
    amount: totalAmountInCents,
    currency: 'usd',
    customer: customer.id,
    // In the latest version of the API, specifying the `automatic_payment_methods` parameter
    // is optional because Stripe enables its functionality by default.
    automatic_payment_methods: {
      enabled: true,
    },
  });

  res.json({
    paymentIntent: paymentIntent.client_secret,
    ephemeralKey: ephemeralKey.secret,
    customer: customer.id,
    publishableKey: 'pk_test_51Ai2s8HlHcPNi5kGEL4NmINijwzczRk0RJfSkEGDaAEs4ZYzZjqMXF8UEQPnYuN8Kl0usMjgQZYcd2ZRtNlNbRNR00hQK8SXLR'
  });
}