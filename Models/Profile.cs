namespace ZaraProfileApi.Models;

public class Profile
{
    public int Id { get; set; }

    public string FullName { get; set; } = string.Empty;

    public string Title { get; set; } = string.Empty;

    public string About { get; set; } = string.Empty;

    public string Email { get; set; } = string.Empty;

    public string LinkedIn { get; set; } = string.Empty;

    public string GitHub { get; set; } = string.Empty;
}