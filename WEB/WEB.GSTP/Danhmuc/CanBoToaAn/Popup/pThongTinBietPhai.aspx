<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pThongTinBietPhai.aspx.cs" Inherits="WEB.GSTP.Danhmuc.CanBoToaAn.Popup.pThongTinBietPhai" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Thông tin biệt phái</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />

    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../..//UI/js/jquery-ui.min.js"></script>

    <script src="../../../../UI/js/chosen.jquery.js"></script>
    <style>
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
        }

        .box {
            height: 450px;
            overflow: auto;
        }

        .boxchung {
            float: left;
        }

        .boder {
            float: left;
            width: 96%;
            padding: 10px 1.5%;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="box">
            <div class="box_nd">
                <div class="boxchung">
                    <h4 class="tleboxchung">Thông tin biệt phái</h4>
                    <div class="boder">
                        <table class="table1">
                            <tr>
                                <td colspan="4"></td>
                            </tr>
                            <tr>
                                <td>Tòa án</td>
                                <td>
                                    <asp:DropDownList CssClass="chosen-select" ID="ddlToaAn" runat="server" Width="300px" AutoPostBack="true" OnSelectedIndexChanged="ddlToaAn_SelectedIndexChanged"></asp:DropDownList>
                                </td>                              
                                <td>Phòng ban</td>
                                <td>
                                    <asp:DropDownList CssClass="chosen-select" ID="ddlPhongBan" runat="server" Width="300px" AutoPostBack="true"></asp:DropDownList>
                                </td> 
                            </tr>
                            <tr>                             
                                <td>Chức vụ <span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList CssClass="chosen-select" ID="ddlChucVu" runat="server" Width="300px" AutoPostBack="true"></asp:DropDownList>
                                </td> 
                                <td>Chức danh <span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList CssClass="chosen-select" ID="ddlChucDanh" runat="server" Width="300px" AutoPostBack="true"></asp:DropDownList>
                                </td> 
                            </tr>
                            <tr>
                                <td>Ngày bắt đầu <span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgaybatdau" runat="server" CssClass="user" Width="150px" MaxLength="10" AutoPostBack="true" OnTextChanged="txtNgaybatdau_TextChanged"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgaybatdau" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtNgaybatdau" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td>Ngày kết thúc <span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgayketthuc" runat="server" CssClass="user" Width="150px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayketthuc" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayketthuc" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="btnUpdate_Click" OnClientClick="return ValidateDataInput();" />
                                    <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                                </td>
                            </tr>
                            <tr>
                                   <td colspan="4">
                                        <div>
                                            <asp:HiddenField ID="hddBietPhaiID" runat="server" Value="0" />
                                        </div>
                                        <asp:Panel runat="server" ID="pndata">
                                            <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                                ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                                <Columns>
                                                    <asp:BoundColumn DataField="Id" Visible="false"></asp:BoundColumn>
                                                    <asp:TemplateColumn ItemStyle-Width="40px" HeaderStyle-Width="40px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                        <HeaderTemplate>
                                                            STT
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <%# Container.ItemIndex + 1 %>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn> 
                                                    <asp:TemplateColumn HeaderStyle-Width="150px" ItemStyle-Width="150px" HeaderStyle-HorizontalAlign="Center">
                                                        <HeaderTemplate>
                                                            Tên cán bộ
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <%#Eval("HOTEN")%>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderStyle-Width="200px" HeaderStyle-HorizontalAlign="Center">
                                                        <HeaderTemplate>
                                                            Tòa án
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <%#Eval("TOAAN") %>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderStyle-Width="250px" HeaderStyle-HorizontalAlign="Center">
                                                        <HeaderTemplate>
                                                            Phòng ban
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <%#Eval("PHONGBAN") %>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                    <asp:BoundColumn DataField="TUNGAY" HeaderText="Ngày bắt đầu" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"  ></asp:BoundColumn>
                                                    <asp:BoundColumn DataField="DENNGAY" HeaderText="Ngày kết thúc" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"  ></asp:BoundColumn>                                    
                                                    <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                        <HeaderTemplate>
                                                            Thao tác
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lbtSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                                CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                            &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                                CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                </Columns>
                                                <HeaderStyle CssClass="header"></HeaderStyle>
                                                <ItemStyle CssClass="chan"></ItemStyle>
                                                <PagerStyle Visible="false"></PagerStyle>
                                            </asp:DataGrid>
                                        </asp:Panel>
                                    </td>
                                </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <script>
            function validate() {
                var ddlToaAn = document.getElementById('<%=ddlToaAn.ClientID%>');
                if (!Common_CheckEmpty(ddlToaAn.value)) {
                    alert('Bạn chưa chọn tòa án.Hãy kiểm tra lại!');
                    ddlToaAn.focus();
                    return false;
                } 
                return true;
            }
        </script>         
        <script>
             function checkDate(sender, args) {
                 var txtNgaybatdau = document.getElementById('<%=txtNgaybatdau.ClientID%>');
                 var arr = txtNgaybatdau.value.split('/');
                 var TuNgay = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                 var txtNgayketthuc = document.getElementById('<%=txtNgayketthuc.ClientID%>');
                 var arr = txtNgayketthuc.value.split('/');
                 var DenNgay = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                 if (DenNgay < TuNgay) {
                     document.getElementById('lbthongbao').innerHTML = 'Ngày kết thúc phải lớn hơn ngày bắt đầu!';
                     document.getElementById('txtNgaybatdau').innerHTML = txtNgaybatdau;
                     txtNgayketthuc.focus();
                 }
             }
        </script>
        <script>
            //-------load parent page when close popup---------------
            window.onunload = refreshParent;
            function refreshParent() {
                window.opener.location.reload();
            }
            function pageLoad(sender, args) {
                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            }
        </script>
    </form>
</body>
</html>
