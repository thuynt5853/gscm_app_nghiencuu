<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.Baocao.Baocaothidua.Danhsach" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../UI/js/Common.js"></script>
 <style type="text/css">
    .modalBackground {
        background-color: #000;
        filter: alpha(opacity=15);
        opacity: 0.65;
    }

    .instancse_tips {
        color: #009900;
        font-weight: bold;
    }

    .instancse_seconds {
        color: #11449e;
    }

    input[type=checkbox] + label {
        color: #009900;
        padding-left: 4px;
        font-style: italic;
    }

    input[type=checkbox]:checked + label {
        color: #f00;
        font-style: normal;
    }

    input[type=radio] + label {
        color: #009900;
        padding-left: 4px;
        font-style: italic;
    }

    input[type=radio]:checked + label {
        color: #f00;
        font-style: normal;
    }
</style>
    <div class="box">
        <div class="box_nd">
           
                    <div style="margin-left: 50px; margin-top: 20px;">
                        <table cellpadding="0px" cellspacing="0px" border="0px">
                            <tr style="height: 28px;">
                                <td style="padding-left: 55px;">
                                    <div runat="server" id="Ra_level_tr_div" style="float: left; height: 25px; padding-bottom: 10px;">
                                        <asp:RadioButtonList ID="Ra_level_trial" runat="server" Font-Bold="True" ForeColor="#009900" Width="600"
                                            RepeatDirection="Horizontal" CellPadding="10">
                                            <asp:ListItem Text="Theo tỉnh" Selected="True" Value="0"></asp:ListItem>
                                            <asp:ListItem Text="Cấp xét xử" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="Sơ thẩm, phúc thẩm tỉnh và danh sách huyện" Value="2"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </td>
                            </tr>
                            <tr style="height: 28px;">
                                <td>
                                    <div style="float: left; margin-left: 68px; margin-top: 25px;">
                                        <asp:DropDownList ID="Drop_Skin" runat="server" Height="19px" OnSelectedIndexChanged="Drop_Skin_SelectedIndexChanged"
                                            AutoPostBack="true" Width="360px">
                                            <asp:ListItem Value="0">Kết quả công tác giải quyết các loại án</asp:ListItem>
                                            <asp:ListItem Value="1">Thống kê tình hình thụ lý và giải quyết án dân sự, hôn nhân và gia đình</asp:ListItem>
                                            <asp:ListItem Value="2">Thống kê án kinh tế, lao động, hành chính</asp:ListItem>
                                            <asp:ListItem Value="3">Thống kê công tác thi hành án hình sự</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </td>
                            </tr>
                            <tr id="Drop_object_div" runat="server" style="height: 28px;">
                                <td>
                                    <div style="float: left; margin-left: 68px; margin-top: 7px;">
                                        <asp:DropDownList ID="Drop_object" runat="server" Height="19px" OnSelectedIndexChanged="Drop_Skin_SelectedIndexChanged"
                                            AutoPostBack="true" Width="360px">
                                             <asp:ListItem Value="">---Tất cả----</asp:ListItem>
                                            <asp:ListItem Value="1">Cụm thi đua số I </asp:ListItem>
                                            <asp:ListItem Value="2">Cụm thi đua số II</asp:ListItem>
                                            <asp:ListItem Value="3">Cụm thi đua số III</asp:ListItem>
                                            <asp:ListItem Value="4">Cụm thi đua số IV </asp:ListItem>
                                            <asp:ListItem Value="5">Cụm thi đua số V </asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </td>
                            </tr>
                            <tr style="height: 28px;">
                                <td>
                                    <div style="width: 500px; float: left; margin-top: 7px;">
                                        <div style="float: left; width: 68px;">Từ ngày</div>
                                        <div style="float: left;">
                                            <asp:TextBox ID="txt_day_from" runat="server" TabIndex="3" Width="100px" Height="21px"></asp:TextBox>
                                            <cc2:CalendarExtender ID="CalendarExtender2" Format="dd/MM/yyyy" PopupPosition="BottomRight"
                                                runat="server" TargetControlID="txt_day_from">
                                            </cc2:CalendarExtender>
                                        </div>
                                        <div style="width: 68px; float: left; margin-left: 90px;">
                                            Đến ngày
                                        </div>
                                        <div style="float: left;">
                                            <asp:TextBox ID="txt_day_to" runat="server" Width="100px" Height="21px" TabIndex="4"></asp:TextBox>
                                            <cc2:CalendarExtender ID="CalendarExtender1" Format="dd/MM/yyyy" PopupPosition="BottomRight"
                                                runat="server" TargetControlID="txt_day_to">
                                            </cc2:CalendarExtender>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div style="height: 50px; width: 470px;">
                                        <div style="float: right; padding-top: 15px; padding-bottom: 8px;">
                                            <asp:Button ID="cmd_exels" runat="server" CssClass="TestingOnliebutton" TabIndex="36"
                                                Height="20px" Text="Báo cáo" Width="68px" OnClick="cmd_Ok_s_Click" />
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                
        </div>
    </div>
    <script>
        function Validate() {
            return true;
        }
    </script>
</asp:Content>
