using System;
using System.Threading.Tasks;
using Microsoft.Azure.ServiceBus;
using Microsoft.Extensions.Configuration;

namespace Thinktectur.Publisher
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var config = new ConfigurationBuilder()
                .AddEnvironmentVariables().Build();

            var builder = new ServiceBusConnectionStringBuilder(config.GetValue<string>("AzureServiceBus"));
            var client = new QueueClient(builder, ReceiveMode.PeekLock);
            while (true)
            {
                await PublishMessageAsync(client);
                Console.WriteLine("Message published");
                System.Threading.Thread.Sleep(10);

            }
        }

        static async Task PublishMessageAsync(QueueClient client)
        {
            var message = $"Thinktecture Sample Message generated at {DateTime.Now.ToLongTimeString()}";
            await client.SendAsync(new Message(System.Text.Encoding.UTF8.GetBytes(message)));
        }
    }
}
