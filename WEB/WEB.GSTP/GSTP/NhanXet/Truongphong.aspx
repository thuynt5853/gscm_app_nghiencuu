<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Truongphong.aspx.cs" Inherits="WEB.GSTP.GSTP.NhanXet.Truongphong" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style type="text/css">
        .yKien_css {
            text-indent: 15px;
            padding: 5px;
        }
    </style>
    <div class="box" style="width: 99.5%; float: left;">
        <div class="box_nd" style="width: 99%; float: left;">
            <div class="truong" style="width: 99%; float: left;">
                <div style="margin-left: 10px;">
                    <span style="font-weight: bold; text-transform: uppercase;">Nhận xét của thẩm tra viên</span>
                    <div style="clear: both;"></div>
                    <div style="float: left; width: 100%; margin: 5px 0px">
                        <asp:TextBox ID="txtYKienThamTraVien" runat="server" TextMode="MultiLine" Height="200px" Width="99%" CssClass="yKien_css"></asp:TextBox>
                    </div>
                    <span style="font-weight: bold; text-transform: uppercase;">Ý kiến của trưởng phòng</span>
                    <div style="clear: both;"></div>
                    <div style="float: left; width: 100%; margin: 5px 0px">
                        <asp:TextBox ID="txtYKienTruongPhong" runat="server" TextMode="MultiLine" Height="200px" Width="99%" CssClass="yKien_css"></asp:TextBox>
                    </div>
                    <asp:Button ID="btnUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="btnUpdate_Click" />
                    <div style="width: 100%; margin: 5px 0px">
                        <asp:Label runat="server" ID="lbthongbao" ForeColor="Red" Text=""></asp:Label>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
