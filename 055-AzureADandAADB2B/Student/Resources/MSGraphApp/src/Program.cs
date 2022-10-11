// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using System;
using System.Threading.Tasks;
using Microsoft.Graph;
using Microsoft.Graph.Auth;
using Microsoft.Identity.Client;

namespace b2c_ms_graph
{
    public static class Program
    {
        static async Task Main(string[] args)
        {
            // Read application settings from appsettings.json (tenant ID, app ID, client secret, etc.)
            AppSettings config = AppSettingsFile.ReadFromJsonFile();

            // Initialize the client credential auth provider
            IConfidentialClientApplication confidentialClientApplication = ConfidentialClientApplicationBuilder
                .Create(config.AppId)
                .WithTenantId(config.TenantId)
                .WithClientSecret(config.ClientSecret)
                .Build();
            ClientCredentialProvider authProvider = new ClientCredentialProvider(confidentialClientApplication);

            // Set up the Microsoft Graph service client with client credentials
            GraphServiceClient graphClient = new GraphServiceClient(authProvider);

            PrintCommands();

            try
            {
                while (true)
                {
                    Console.Write("Enter command, then press ENTER: ");
                    string decision = Console.ReadLine();
                    switch (decision.ToLower())
                    {
                        case "1":
                            await UserService.ListUsers(graphClient);
                            break;
                        case "2":
                            await UserService.GetUserById(graphClient);
                            break;
                        case "3":
                            await UserService.GetUserBySignInName(config, graphClient);
                            break;
                        case "4":
                            await UserService.DeleteUserById(graphClient);
                            break;
                        case "5":
                            await UserService.SetPasswordByUserId(graphClient);
                            break;
                        case "6":
                            await UserService.BulkCreate(config, graphClient);
                            break;
                        case "7":
                            await UserService.CreateUserWithCustomAttribute(graphClient, config.B2cExtensionAppClientId, config.TenantId);
                            break;
                        case "8":
                            await UserService.ListUsersWithCustomAttribute(graphClient, config.B2cExtensionAppClientId);
                            break;
                        case "help":
                            Program.PrintCommands();
                            break;
                        case "exit":
                            return;
                        default:
                            Console.ForegroundColor = ConsoleColor.Red;
                            Console.WriteLine("Invalid command. Enter 'help' to show a list of commands.");
                            Console.ResetColor();
                            break;
                    }

                    Console.ResetColor();
                }
            }
            catch (Exception ex)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine($"An error occurred: {ex}");
                Console.ResetColor();
            }           
            Console.ReadLine();
        }

        private static void PrintCommands()
        {
            Console.ResetColor();
            Console.WriteLine();
            Console.WriteLine("Command  Description");
            Console.WriteLine("====================");
            Console.WriteLine("[1]      Get all users (one page)");
            Console.WriteLine("[2]      Get user by object ID");
            Console.WriteLine("[3]      Get user by sign-in name");
            Console.WriteLine("[4]      Delete user by object ID");
            Console.WriteLine("[5]      Update user password");
            Console.WriteLine("[6]      Create users (bulk import)");
            Console.WriteLine("[7]      Create user with custom attributes and show result");
            Console.WriteLine("[8]      Get all users (one page) with custom attributes");
            Console.WriteLine("[help]   Show available commands");
            Console.WriteLine("[exit]   Exit the program");
            Console.WriteLine("-------------------------");
        }
    }
}
