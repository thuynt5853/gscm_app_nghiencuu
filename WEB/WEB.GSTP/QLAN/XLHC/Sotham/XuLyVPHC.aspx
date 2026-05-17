<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="XuLyVPHC.aspx.cs" Inherits="WEB.GSTP.QLAN.XLHC.Sotham.XuLyVPHC" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddMaGD" runat="server" Value="0" />
    <asp:HiddenField ID="hddVuAnID" runat="server" Value="0" />

    <div style="margin: 5px; text-align: center; width: 95%; padding-top: 25px;">
    </div>
    <div style="margin: 5px; text-align: center; width: 95%; color: red;">
        <asp:Literal ID="lstMsgT" runat="server"></asp:Literal>
    </div>
    <div style="text-align: center; margin: 5px; width: 95%; padding-top: 25px;">
        <h3>Xử lý vi phạm hành chính tại phiên tòa</h3>
    </div>
    <div class="box">
        <div class="box_nd">
            <div>
                <div class="boxchung">
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td style="width: 180px">
                                    <h4>Tổng số trường hợp áp dụng xử lý vi phạm hành chính</h4>
                                </td>
                                <td style="width: 200px">
                                    <asp:TextBox ID="txtTongso_truonghop" runat="server" Width="100px" CssClass="user align_right" onkeypress="return isNumber(event)"></asp:TextBox>
                                </td>

                                <td></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="box_nd">

            <div class="boxchung">
                <h4 class="tleboxchung">Hình phạt chính</h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td style="width: 180px">
                                <strong>Phạt cảnh cáo</strong>
                            </td>
                            <td style="width: 200px;">
                                <asp:TextBox ID="txtPhatcanhcao" runat="server" Width="100px" CssClass="user align_right" onkeypress="return isNumber(event)"></asp:TextBox>
                            </td>

                            <td></td>
                        </tr>
                        <tr>
                            <td>
                                <table style="width: 100%">
                                    <tr>
                                        <td style="width: 50px; border-right: 1px solid #cccccc;">
                                            <strong>Phạt tiền</strong>
                                        </td>
                                        <td>
                                            <div style="height: 20px">
                                                Số trường hợp
                                            </div>
                                            <br />
                                            <div style="height: 20px">
                                                Số tiền(VND)
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td>
                                <div style="padding-bottom: 8px">
                                    <asp:TextBox ID="txtSoTruongHop" runat="server" Width="100px" CssClass="user align_right" onkeypress="return isNumber(event)"></asp:TextBox>
                                </div>
                                <div style="height: 20px; padding-bottom: 10px;">
                                    <asp:TextBox ID="txtSoTien" runat="server" Width="100px" CssClass="user align_right" onkeypress="return isNumber(event)"></asp:TextBox>
                                    <b>VND</b>
                                </div>
                            </td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>
                                <strong>Tịch thu tang vật, Phương tiện</strong>
                            </td>
                            <td>
                                <asp:TextBox ID="txttichthuphuongtien_HP" runat="server" Width="100px" CssClass="user align_right" onkeypress="return isNumber(event)"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>

        <div class="box_nd">

            <div class="boxchung">
                <h4 class="tleboxchung">Hình phạt bổ xung</h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td style="width: 180px">Tịch thu tang vật,phương tiện...
                            </td>
                            <td>
                                <asp:TextBox ID="txtTichthubosung" runat="server" Width="100px" CssClass="user align_right" onkeypress="return isNumber(event)"></asp:TextBox>
                            </td>

                            <td></td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <asp:Label ID="lbthongbao" runat="server" Text="" ForeColor="Red"></asp:Label>
        <div style="margin: 5px; text-align: center; width: 95%">
            <asp:Button ID="cmdUpdateBottom" runat="server" CssClass="buttoninput"
                Text="Lưu" OnClick="cmdUpdateBottom_Click" OnClientClick="return Validate();" />
        </div>
    </div>







    <script>
        function pageLoad(sender, args) {
            $(function () {
                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            });
        }
    </script>
</asp:Content>
