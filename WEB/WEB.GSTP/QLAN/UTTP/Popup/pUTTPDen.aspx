<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pUTTPDen.aspx.cs" Inherits="WEB.GSTP.QLAN.UTTP.Popup.pUTTPDen" %>

<%--MasterPageFile="~/MasterPages/GSTP.Master"--%>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cập nhật quyết định và hình phạt</title>
   
    
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />

    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    <script src="../../../../UI/js/Common.js"></script>

    <script src="../../../../UI/js/chosen.jquery.js"></script>
     <style>
        body {

            min-width: 0px;
            min-height:0px;
        }



        .box {
            overflow: auto;
            position: absolute;
            width:100%
        }

        .boxchung {
            float: left;
        }

        .boder {
            float: left;
            padding: 10px 1.5%;
        }
        input{
            height:28px !important;
        }
         </style>
</head>
<body>
    
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Thêm mới/Sửa Thông tin UTTP</h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">
                                        <tr>
                                            <td>
                                                <div style="float: left; margin-top: 8px;">
                                                    <div style="float: left; width: 115px; text-align: left; margin-right: 25px;">Cơ quan UTTP<span class="batbuoc">(*)</span></div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txttCoQuanUTTP" CssClass="user" runat="server" Width="212px"></asp:TextBox>
                                                    </div>
                                                    <div style="float: left; width: 115px; text-align: left;margin-left: 10px; margin-right: 25px;">Quốc gia UT<span class="batbuoc">(*)</span></div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddllQuocGiaUT" CssClass="chosen-select" runat="server" Width="235px">
                                                            
                                                        </asp:DropDownList>
                                                    </div>
                                                    
                                                </div>

                                                <div style="float: left; margin-top: 8px;">
                                                    <div style="float: left; width: 115px; text-align: left; margin-right: 25px;">Văn bản UT<span class="batbuoc">(*)</span></div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txttVanBanUT" TextMode="MultiLine" runat="server" CssClass="user" Width="597px" MaxLength="250"></asp:TextBox>
                                                    </div>
                                                    
                                                </div>
                                                <div style="float: left; margin-top: 8px;">
                                                    <div style="float: left; width: 115px; text-align: left; margin-right: 25px;">Nội dung UT</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txttNoiDungUT" TextMode="MultiLine" CssClass="user" runat="server" Width="597px"></asp:TextBox>
                                                    </div>
                                                    
                                                </div>
                                                
                                                <div style="float: left;  margin-top: 8px;">
                                                    <div style="float: left; width: 115px; text-align: left; margin-right: 25px;">Kết quả thực hiện UT:</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddllKetQuaThucHienUTTP" CssClass="chosen-select" runat="server" Width="210px">
                                                            <asp:ListItem Value="0" Text="-- Tất cả --"></asp:ListItem>
                                                            <asp:ListItem Value="1" Text="Đã thực hiện"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text="Từ chối thực hiện"></asp:ListItem>
                                                            <asp:ListItem Value="3" Selected Text="Chưa thực hiện"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; width: 127px; text-align: left;margin-left: 10px; margin-right: 10px;">Ngày có kết quả thực hiện UTTP</div>
                                                    <div style="float: left;">
                                                         <asp:TextBox ID="txttNgayCoKetQuaThuHienUTTP" runat="server" CssClass="user" Width="240px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txttNgayCoKetQuaThuHienUTTP" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txttNgayCoKetQuaThuHienUTTP" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator5" runat="server" ControlExtender="MaskedEditExtender5" ControlToValidate="txttNgayCoKetQuaThuHienUTTP" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                    
                                                </div>

                                                <div style="float: left; margin-top: 8px;">
                                                    <div style="float: left; width: 115px; text-align: left; margin-right: 25px;">Người thực hiện UT</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddllNguoiThucHienUT" CssClass="chosen-select" runat="server" Width="210px">
                                                            
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; width: 127px; text-align: left;margin-left: 10px; margin-right: 10px;">Ngày nhận UTTP<span class="batbuoc">(*)</span></div>
                                                    <div style="float: left;">
                                                         <asp:TextBox ID="txttNgayNhanUTTP" runat="server" CssClass="user" Width="240px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txttNgayNhanUTTP" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txttNgayNhanUTTP" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator6" runat="server" ControlExtender="MaskedEditExtender6" ControlToValidate="txttNgayNhanUTTP" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                </div>

                                                <div style="float: left; margin-top: 8px;">
                                                    <div style="float: left; width: 115px; text-align: left; margin-right: 25px;">Ghi chú</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txttGhiChu" TextMode="MultiLine" CssClass="user" runat="server" Width="597px"></asp:TextBox>
                                                    </div>
                                                    
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr><td style="width: 150px;" align="left"><asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label></td></tr>
                    <tr>
                        
                        <td align="center">
                            <asp:HiddenField ID="hddid" runat="server" Value="0" />
                            
                            <asp:Button ID="Button1" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="lbLuu_Click" />
                            <asp:Button ID="Button2" runat="server" CssClass="buttoninput" Text="Lưu & Quay lại" OnClick="lbLuuAndQuayLai_Click" />
                            <asp:Button ID="Button3" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="lbQuayLai_Click" />
                        </td>
                    </tr>
                    
                </table>
            </div>
        </div>
    </div>
    <script>
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
        function ReloadParent() {
            window.onunload = function (e) {
                opener.ReLoadGrid();
            };
            window.close();
        }
    </script>
    </form>
</body>
</html>

