# Setup all SOAP related thingies
@wsdl = SOAP::WSDLDriverFactory.new("#{File.dirname(__FILE__)}/Payment.wsdl")
@soap = @wsdl.create_rpc_driver
@soap.options["protocol.http.basic_auth"] << [URL, USER_ID, PASSWORD]
  
# Used for debug output
@soap.wiredump_dev = STDOUT


def cancel(original_reference)
	# Since soap4r doesn't set the modificationAmount (which is a ComplexType)
	# to xsi:nil when it's empty, we must create the whole thing by hand.

          cancel_elt = SOAP::SOAPElement.new("ns1:cancel")
          cancel_elt.extraattr['xmlns:ns1'] = "http://payment.services.adyen.com"
          modification_req_elt = SOAP::SOAPElement.new("ns1:modificationRequest")
          merchant_account_elt = SOAP::SOAPElement.new("ns1:merchantAccount", MERCHANT)
          original_ref_elt = SOAP::SOAPElement.new("ns1:originalReference", original_reference)

          modification_req_elt.add(merchant_account_elt)
          modification_req_elt.add(original_ref_elt)
          cancel_elt.add(modification_req_elt)

        @result = @soap.cancel(cancel_elt)
end

def refund(original_reference, value, currency)
	# Since all attributes are filled, we can send it in a much easier way than the cancel action
	@result = @soap.refund('modificationRequest' => {
							'merchantAccount' => MERCHANT,
							'originalReference' => original_reference,
							'modificationAmount' => {
								'value' => value,
								'currency' => currency
							}
                                			})	
end

# Usage
cancel("821284928392")
refund("829821938321", "1000", "EUR")
