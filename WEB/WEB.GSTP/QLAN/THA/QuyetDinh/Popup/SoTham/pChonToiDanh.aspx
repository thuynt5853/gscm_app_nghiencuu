<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeBehind="pChonToiDanh.aspx.cs" Inherits="WEB.GSTP.QLAN.THA.QuyetDinh.Popup.SoTham.pChonToiDanh" ValidateRequest="false" %>

<%--MasterPageFile="~/MasterPages/GSTP.Master"--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cập nhật quyết định và hình phạt</title>

    <link href="../../../../../UI/css/style.css" rel="stylesheet" />
    <script src="../../../../../UI/js/Common.js"></script>
    <link href="../../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../../UI/css/chosen.css" rel="stylesheet" />

    <link href="../../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../../UI/js/jquery-ui.min.js"></script>

    <script src="../../../../../UI/js/chosen.jquery.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                <style type="text/css">
                    body {
                        width: 98%;
                        margin-left: 1%;
                        min-width: 0px;
                        overflow-y: hidden;
                        overflow-x: auto;
                    }

                    .tdWidthTblToaAn {
                        width: 120px;
                    }

                    .check_list_vertical table td {
                        padding-right: 15px;
                    }

                    .boxchung {
                        height: 750px;
                        overflow: auto;
                    }
                </style>
                <div class="boxchung">
                    <h4 class="tleboxchung">Cập nhật quyết định và hình phạt</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td style="width: 60px;"><b>Bị cáo</b></td>
                                <td style="width: 260px;">
                                    <b>
                                        <asp:DropDownList ID="dropBiCao"
                                            runat="server" CssClass="chosen-select" Width="250px" Height="31px"
                                            AutoPostBack="true" OnSelectedIndexChanged="dropBiCao_SelectedIndexChanged">
                                        </asp:DropDownList></b>
                                </td>
                                <td style="width: 60px;"><b>Bộ luật</b></td>
                                <td>
                                    <asp:DropDownList ID="dropBoLuat" runat="server"
                                        CssClass="chosen-select" Width="250px" Height="31px"
                                        AutoPostBack="true" OnSelectedIndexChanged="dropBoLuat_SelectedIndexChanged">
                                    </asp:DropDownList></td>
                            </tr>
                            <tr>
                                <td><b>Tên tội danh</b></td>
                                <td>
                                    <asp:TextBox ID="txtTenToiDanh" runat="server" CssClass="user"
                                        Width="250px" Height="25px"></asp:TextBox>
                                </td>
                                <td><b>Điểm</b></td>
                                <td>
                                    <asp:TextBox ID="txtDiem" runat="server" CssClass="user" Width="60px" Height="25px"></asp:TextBox>

                                    <b style="width: 50px;">Khoản</b>
                                    <asp:TextBox ID="txtKhoan" runat="server" CssClass="user" Width="60px" Height="25px"></asp:TextBox>

                                    <b style="width: 50px;">Điều</b>
                                    <asp:TextBox ID="txtDieu" runat="server" CssClass="user" Width="60px" Height="25px"></asp:TextBox>

                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td colspan="3">
                                    <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput"
                                        Text="Tìm kiếm" OnClick="cmdTimkiem_Click" />
                                    <input type="button" class="buttoninput" onclick="window.close();" value="Đóng" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <div style="float: left; width: 100%; text-align: left; font-style: italic;">
                                        <b>Ghi chú</b><br />
                                        1. Chọn các điều luật cần gán cho bị cáo<br />
                                        2. Ấn chọn "Cập nhật" để gán điều luật áp dụng cho bị cáo
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <div>
                                        <asp:HiddenField ID="hddToiDanh" runat="server" Value="0" />
                                        <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                    </div>
                                    <asp:Panel runat="server" ID="pndata" Visible="false">
                                        <div class="phantrang">
                                            <div class="sobanghi">
                                                <asp:Button ID="cmdSave" runat="server" CssClass="buttoninput"
                                                    Text="Cập nhật" OnClick="cmdSave_Click" />

                                            </div>
                                            <div class="sotrang">
                                                <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                                    OnClick="lbTBack_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                                    Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                                <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                                                <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                                                    Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                                                    Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                                                    Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                                                    Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                                <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                                                <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                                                    Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                                                    OnClick="lbTNext_Click"></asp:LinkButton>
                                            </div>
                                        </div>
                                        <asp:HiddenField ID="hddOld" runat="server" Value="" />
                                        <asp:Repeater ID="rpt" runat="server" OnItemDataBound="rpt_ItemDataBound">
                                            <HeaderTemplate>
                                                <table class="table2" width="100%" border="1">
                                                    <tr class="header">
                                                        <td width="42">
                                                            <div align="center"><strong>Chọn</strong></div>
                                                        </td>
                                                        <td width="50px">
                                                            <div align="center"><strong>Điều</strong></div>
                                                        </td>
                                                        <td width="50px">
                                                            <div align="center"><strong>Khoản</strong></div>
                                                        </td>

                                                        <td width="50px">
                                                            <div align="center"><strong>Điểm</strong></div>
                                                        </td>
                                                        <td>
                                                            <div align="center"><strong>Tội danh</strong></div>
                                                        </td>
                                                        <%-- <td width="100">
                                                                <div align="center"><strong>Ngày tạo</strong></div>
                                                            </td>--%>
                                                    </tr>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr>
                                                    <td>
                                                        <div style="float: left; width: 100%; text-align: center;">
                                                            <asp:CheckBox ID="chk" runat="server" />
                                                        </div>
                                                        <asp:HiddenField ID="hddBoLuatID" runat="server" Value='<%#Eval("LuatID") %>' />
                                                        <asp:HiddenField ID="hddToiDanhID" runat="server" Value='<%#Eval("ID") %>' />
                                                        <asp:HiddenField ID="hddLoai" runat="server" Value='<%#Eval("Loai") %>' />
                                                    </td>

                                                    <td><%# Eval("Dieu") %></td>
                                                    <td><%# Eval("Khoan") %></td>
                                                    <td><%# Eval("Diem") %></td>
                                                    <td><%#Eval("TenToiDanh") %></td>
                                                    <%-- <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayTao")) %></td>--%>
                                                </tr>
                                            </ItemTemplate>
                                            <FooterTemplate></table></FooterTemplate>
                                        </asp:Repeater>

                                        <div class="phantrang">
                                            <div class="sobanghi">
                                                <asp:Button ID="cmdSave2" runat="server" CssClass="buttoninput" Text="Cập nhật" OnClick="cmdSave_Click" />

                                            </div>
                                            <div class="sotrang">
                                                <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                                    OnClick="lbTBack_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                                                    Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                                <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                                                <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                                                    Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                                                    Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                                                    Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                                                    Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                                <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                                                <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                                                    Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                                                    OnClick="lbTNext_Click"></asp:LinkButton>
                                            </div>
                                        </div>
                                    </asp:Panel>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <script type="text/javascript">
                    function pageLoad(sender, args) {

                        var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                        for (var selector in config) { $(selector).chosen(config[selector]); }
                    }
                    function ClosePopup() {
                   <%-- var link = "/QLAN/AHS/SoTham/BanAnST/popup/pToiDanh.aspx?aID=<%=BanAnID%>&bID=<%=BiCaoID%>";
                    window.location.href = link;--%>
                        window.close();
                    }
                </script>
                <script type="text/javascript">
                    window.onunload = refreshParent;
                    function refreshParent() {
                        window.opener.location.reload();
                    }
                </script>
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
            <ProgressTemplate>
                <div class="processmodal">
                    <div class="processcenter">
                        <img src="/UI/img/process.gif" />
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
    </form>
</body>
</html>
