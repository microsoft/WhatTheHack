using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace RockPaperScissorsBoom.Server.Data.Migrations
{
    public partial class InitialCreate : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Competitors",
                columns: table => new
                {
                    Id = table.Column<Guid>(nullable: false),
                    Name = table.Column<string>(nullable: true),
                    BotType = table.Column<string>(nullable: true),
                    Url = table.Column<string>(nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Competitors", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "GameRecords",
                columns: table => new
                {
                    Id = table.Column<Guid>(nullable: false),
                    GameDate = table.Column<DateTime>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_GameRecords", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "BotRecords",
                columns: table => new
                {
                    Id = table.Column<Guid>(nullable: false),
                    GameRecordId = table.Column<Guid>(nullable: true),
                    CompetitorId = table.Column<Guid>(nullable: true),
                    Wins = table.Column<int>(nullable: false),
                    Losses = table.Column<int>(nullable: false),
                    Ties = table.Column<int>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BotRecords", x => x.Id);
                    table.ForeignKey(
                        name: "FK_BotRecords_Competitors_CompetitorId",
                        column: x => x.CompetitorId,
                        principalTable: "Competitors",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_BotRecords_GameRecords_GameRecordId",
                        column: x => x.GameRecordId,
                        principalTable: "GameRecords",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_BotRecords_CompetitorId",
                table: "BotRecords",
                column: "CompetitorId");

            migrationBuilder.CreateIndex(
                name: "IX_BotRecords_GameRecordId",
                table: "BotRecords",
                column: "GameRecordId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "BotRecords");

            migrationBuilder.DropTable(
                name: "Competitors");

            migrationBuilder.DropTable(
                name: "GameRecords");
        }
    }
}
