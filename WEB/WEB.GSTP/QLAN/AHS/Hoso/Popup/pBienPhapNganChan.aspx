<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pBienPhapNganChan.aspx.cs" Inherits="WEB.GSTP.QLAN.AHS.Hoso.Popup.pBienPhapNganChan" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Biện pháp ngăn chặn</title>
        <link href="../../../../UI/css/style.css" rel="stylesheet" />
    
<script src="../../../../UI/js/chosen.jquery.js"></script>
    <script src="../../../../UI/js/Common.js"></script>
    <style>  body {
                    width: 98%;
                    margin-left: 1%;
                    min-width: 0px;
                    overflow-y: hidden;
                    overflow-x: auto;
                }</style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:HiddenField ID="hddID" runat="server" Value="0" />
        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
        <div class="box">
            <div class="box_nd">
                <div class="truong">

                    <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                        <asp:Literal ID="lstMsgT" runat="server"></asp:Literal>
                    </div>
                    <div class="boxchung">
                        <h4 class="tleboxchung">Biện pháp ngăn chặn</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">
                                <tr>
                                    <td style="width:155px;">Bị can<span class="batbuoc">(*)</span></td>
                                    <td>
                                         <asp:DropDownList ID="dropBiCao" CssClass="chosen-select"
                                                runat="server" Width="250px"
                                                AutoPostBack="true" OnSelectedIndexChanged="dropBiCao_SelectedIndexChanged">
                                            </asp:DropDownList>
                                      <%-- <asp:Literal ID ="lttBiCao" runat="server"></asp:Literal>--%>
                                    </td>
                                    <td colspan="2"></td>
                                </tr>
                                <tr>
                                    <td>Biện pháp ngăn chặn</td>
                                    <td>
                                        <asp:DropDownList ID="dropBienPhapNganChan" CssClass="chosen-select" runat="server" Width="200px">
                                        </asp:DropDownList></td>
                                    <td style="width:210px;">Đơn vị ra quyết định</td>
                                    <td>
                                        <asp:DropDownList ID="dropDV" CssClass="chosen-select" runat="server" Width="200px">
                                        </asp:DropDownList></td>
                                </tr>
                                <tr>
                                    <td>Ngày bắt đầu có hiệu lực<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNgayBatDau" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayBatDau"
                                            Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayBatDau"
                                            Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                    <td>Ngày hết hiệu lực hoặc ngày được tha</td>
                                    <td>
                                        <asp:TextBox ID="txtNgayKT" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayKT"
                                            Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayKT"
                                            Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                                            <asp:Literal ID="lstMsgB" runat="server"></asp:Literal>
                                        </div>
                                        <div style="margin: 5px; text-align: center; width: 95%">
                                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput"
                                                Text="Lưu" OnClick="cmdUpdate_Click" OnClientClick="return validate();" />
                                             <input type="button" class ="buttoninput"  onclick="window.close();" value="Đóng" />
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <asp:Panel runat="server" ID="pndata">
                        <div class="phantrang">
                            <div class="sobanghi">
                                <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
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
                        <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                            <HeaderTemplate>
                                <table class="table2" width="100%" border="1">
                                    <tr class="header">
                                        <td width="42">
                                            <div align="center"><strong>TT</strong></div>
                                        </td>
                                        <td>
                                            <div align="center"><strong>Tên bị can</strong></div>
                                        </td>
                                        <td width="120px">
                                            <div align="center"><strong>Biện pháp ngăn chặn</strong></div>
                                        </td>
                                        <td width="140px">
                                            <div align="center"><strong>Ngày bắt đầu có hiệu lực</strong></div>
                                        </td>
                                        <td width="220px">
                                            <div align="center"><strong>Ngày hết hiệu lực hoặc ngày được tha</strong></div>
                                        </td>
                                        <%--<td width="70px">
                                            <div align="center"><strong>Thao tác</strong></div>
                                        </td>--%>
                                    </tr>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("STT") %></td>
                                    <td><%#Eval("HoTen") %></td>
                                    <td><%# Eval("TenBienPhapNganChan") %></td>

                                    <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayBatDau")) %></td>
                                    <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayKetThuc")) %></td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate></table></FooterTemplate>
                        </asp:Repeater>

                        <div class="phantrang">
                            <div class="sobanghi">
                                <asp:HiddenField ID="hdicha" runat="server" />
                                <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
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
                </div>
            </div>
        </div>
        <script>
            function pageLoad(sender, args) {

                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            }
            function validate() {

                var txtNgayBatDau = document.getElementById('<%=txtNgayBatDau.ClientID%>');
                if (!Common_CheckEmpty(txtNgayBatDau.value)) {
                    alert('Bạn chưa nhập ngày bắt đầu có hiệu lực. Hãy kiểm tra lại!');
                    txtNgayBatDau.focus();
                    return false;
                }
                var txtNgayKetThuc = document.getElementById('<%=txtNgayKT.ClientID%>');
                if (!Common_CheckEmpty(txtNgayKetThuc.value)) {
                    alert('Bạn chưa nhập ngày hết hiệu lực hoặc ngày được tha. Hãy kiểm tra lại!');
                    txtNgayKetThuc.focus();
                    return false;
                }
                return true;
            }


        </script>
    </form>
</body>
</html>
