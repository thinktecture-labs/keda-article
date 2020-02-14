using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;

namespace Thinktecture.MessageTransformer
{
    public static class MessageTransformer
    {
        [FunctionName("TransformMessage")]
        [return: ServiceBus("outbound", Connection = "OutboundQueue")]
        public static string Run([ServiceBusTrigger("inbound", Connection = "InboundQueue")]string message, ILogger log)
        {
            if (string.IsNullOrWhiteSpace(message))
            {
                log.LogWarning($"Bad Request: received NULL or empty message");
                throw new InvalidOperationException("Received invalid Message");
            }
            log.LogInformation($"Received Message '{message}' for transformation)");

            var chars = message.ToCharArray();
            Array.Reverse(chars);
            var result = new string(chars);

            log.LogInformation($"Transformed Message to '{result}'");
            return result;
        }
    }
}
