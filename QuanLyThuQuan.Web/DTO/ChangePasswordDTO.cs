﻿namespace QuanLyThuQuan.Web.DTO;

public class ChangePasswordDTO
{
    public string Password { get; set; } = string.Empty;
    public string ConfirmPassword { get; set; } = string.Empty;
    public string NewPassword { get; set; } = string.Empty;
}
