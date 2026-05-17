<%--Màn hiển thị danh sách thống kê quá hạn--%>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pTKQuaHan.aspx.cs" Inherits="WEB.GSTP.QLAN.AHN.Hoso.Popup.pTKQuaHan" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Danh sách thống kê quá hạn</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/chosen.jquery.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <style>
            body {
                width: 98%;
                margin-left: 1%;
                min-width: 0px;
                overflow: auto;
            }

            .cssMargin {
                margin-bottom: 30px;
            }

            .tleboxchung {
                position: absolute;
                margin-left: 15px;
                background: #ffe869;
                z-index: 2;
                padding: 0 2px;
                white-space: nowrap;
                border: solid 1px #dcdcdc;
                padding: 5px 10px;
                border-radius: 10px;
                font-weight: bold;
                text-transform: uppercase;
            }
        </style>
        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
        <asp:Button ID="cmdLoadTKQuaHan" runat="server" Style="display: none;" Enabled="true" OnClick="cmdLoadTKQuaHan_Click" />
        <asp:Button ID="cmdLoadTKQuaHan_GuiDL" runat="server" Style="display: none;" Enabled="true" OnClick="cmdLoadTKQuaHan_GuiDL_Click" />
        <asp:Button ID="cmdLoadTKQuaHan_Sua" runat="server" Style="display: none;" Enabled="true" OnClick="cmdLoadTKQuaHan_Sua_Click" />

        <table class="table1">
            <tr>
                <td colspan="2">
                    <div class="boxchung">
                        <h4 class="tleboxchung">Tìm kiếm</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">
                                <tr>
                                    <td>
                                        <div class="box_nd">
                                            <div style="float: left; width: 1050px">

                                                <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Năm</div>
                                                <div style="float: left;">
                                                    <asp:DropDownList ID="dropNam" CssClass="chosen-select" runat="server" Width="248px">
                                                    </asp:DropDownList>
                                                </div>
                                                <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tháng</div>
                                                <div style="float: left;">
                                                    <asp:DropDownList ID="dropThang" CssClass="chosen-select" runat="server" Width="248px">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td align="center" colspan="2">
                    <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                    <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                    <asp:Button ID="cmdThemmoi" runat="server" CssClass="buttoninput" Text="Thêm mới" OnClick="cmdThemmoi_Click" />
                </td>
            </tr>
            <tr>
                <td colspan="2" align="left">
                    <div class="phantrang">
                        <div class="sobanghi">
                            <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                        </div>
                        <div class="sotrang">
                            <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                OnClick="lbTBack_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                            <asp:Label ID="lbTStep1" runat="server" Text="..." Visible="false"></asp:Label>
                            <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:Label ID="lbTStep6" runat="server" Text="..." Visible="false"></asp:Label>
                            <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                OnClick="lbTNext_Click"></asp:LinkButton>
                            <asp:DropDownList ID="ddlPageCount" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount_SelectedIndexChanged">
                                <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                <asp:ListItem Value="500" Text="500"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div style="text-align: center">
                        <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                            PageSize="20" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                            CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                            ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgList_ItemCommand">
                            <Columns>
                                <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                <asp:TemplateColumn HeaderStyle-Width="15px">
                                    <HeaderTemplate>STT</HeaderTemplate>
                                    <ItemTemplate>
                                        <%# (Container.ItemIndex + 1) + (dgList.PageSize * dgList.CurrentPageIndex) %>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn>
                                    <HeaderTemplate>
                                        Kỳ thống kê
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%# Eval("THANG") + "/" + Eval("NAM") %>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="150px">
                                    <HeaderTemplate>
                                        Người nhập
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#Eval("NGUOITAO")%>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="150px">
                                    <HeaderTemplate>
                                        Người sửa
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#Eval("NGUOISUA")%>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="150px">
                                    <HeaderTemplate>
                                        Số vụ quá hạn
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#Eval("SOVUAN_QUAHAN")%>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="150px">
                                    <HeaderTemplate>
                                        Thao tác
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Button ID="btnSua" runat="server" Text="Sửa" CommandName="Sua" CommandArgument='<%# Eval("ID") %>' />
                                        <asp:Button ID="btnXoa" runat="server" Text="Xóa" CommandName="Xoa" OnClientClick="return confirm('Xác nhận xoá thống kê quá hạn đã chọn?');" CommandArgument='<%# Eval("ID") %>' />
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                            </Columns>
                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                        </asp:DataGrid>
                    </div>
                    <div class="phantrang">
                        <div class="sobanghi">
                            <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                        </div>
                        <div class="sotrang">
                            <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                OnClick="lbTBack_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active" Visible="true"
                                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                            <asp:Label ID="lbBStep1" runat="server" Text="..." Visible="false"></asp:Label>
                            <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:Label ID="lbBStep6" runat="server" Text="..." Visible="false"></asp:Label>
                            <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                OnClick="lbTNext_Click"></asp:LinkButton>
                            <asp:DropDownList ID="ddlPageCount2" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount2_SelectedIndexChanged">
                                <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                <asp:ListItem Value="500" Text="500"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </td>
            </tr>
        </table>
        <!-- Nền mờ khi hiển thị popup -->
        <div id="overlay" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background-color: rgba(0, 0, 0, 0.5); /*  màu nền tối mờ */
z-index: 999; /* dưới popup một lớp */">
        </div>
        <script type="text/javascript">
            function pageLoad(sender, args) {
                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            }
            $(window).on("beforeunload", function () {
                return window.opener.HideModalDiv();
            })
            function showOverlay() {
                document.getElementById("overlay").style.display = "block";
            }

            function hideOverlay() {
                document.getElementById("overlay").style.display = "none";
            }
            function HideModalDivTKQuaHan() {
                document.getElementById("overlay").style.display = "none";
                $("#<%= cmdLoadTKQuaHan.ClientID %>").click();
            }
            function HideModalDivTKQuaHan_GuiDL() {
                document.getElementById("overlay").style.display = "none";
                $("#<%= cmdLoadTKQuaHan_GuiDL.ClientID %>").click();
            }
            function HideModalDivTKQuaHan_Sua() {
                document.getElementById("overlay").style.display = "none";
                $("#<%= cmdLoadTKQuaHan_Sua.ClientID %>").click();
            }
        </script>
    </form>

</body>
</html>
