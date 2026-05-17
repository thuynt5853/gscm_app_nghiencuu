<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.Baocao.Phulucquochoi.Danhsach" %>

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
                                <td>
                                    <div style="float: left; margin-left: 68px;">
                                        <asp:DropDownList ID="Drop_Skin" runat="server" Height="19px" CssClass="chosen-select"  OnSelectedIndexChanged="Drop_Skin_SelectedIndexChanged"
                                            AutoPostBack="true" Width="200px">
                                        </asp:DropDownList>
                                    </div>
                                    <div style="float: left; margin-left: 1px;">
                                        <asp:DropDownList ID="Drop_Options" runat="server" Height="19px" CssClass="chosen-select"  Width="200px" OnSelectedIndexChanged="Drop_Options_SelectedIndexChanged"
                                            AutoPostBack="true">
                                        </asp:DropDownList>
                                    </div>
                                </td>
                            </tr>
                            <tr runat="server" id="tr_transfer_records" style="height: 28px; display: none; margin-top: 7px;">
                                <td>
                                    <div style="margin-left: 68px; float: left;">
                                        <label style="color: #009900; font-size: 14px;">Tính tạm đình chỉ và chuyển hồ sơ</label>
                                    </div>
                                    <div style="margin-left: 18px; float: left;">
                                        <asp:RadioButtonList ID="Ra_transfer_records" runat="server" Font-Bold="True" ForeColor="#009900" Width="150px"
                                            RepeatDirection="Horizontal" CellPadding="5">
                                            <asp:ListItem Text="Không" Selected="True" Value="0"></asp:ListItem>
                                            <asp:ListItem Text="có" Value="1"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </td>
                            </tr>
                            <tr style="height: 28px; display: block; margin-top: 7px;">
                                <td>
                                    <div style="width: 500px; float: left;">
                                        <div style="float: left; width: 68px;">Từ ngày</div>
                                        <div style="float: left;">
                                            <asp:TextBox ID="txt_day_from" runat="server" TabIndex="3" Width="100px" Height="21px"></asp:TextBox>
                                            <cc2:CalendarExtender ID="CalendarExtender2" Format="dd/MM/yyyy" PopupPosition="BottomRight"
                                                runat="server" TargetControlID="txt_day_from"></cc2:CalendarExtender>
                                        </div>
                                        <div style="width: 68px; float: left; margin-left: 90px;">
                                            Đến ngày
                                        </div>
                                        <div style="float: left;">
                                            <asp:TextBox ID="txt_day_to" runat="server" Width="100px" Height="21px" TabIndex="4"></asp:TextBox>
                                            <cc2:CalendarExtender ID="CalendarExtender1" Format="dd/MM/yyyy" PopupPosition="BottomRight"
                                                runat="server" TargetControlID="txt_day_to"></cc2:CalendarExtender>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr runat="server" id="day_check_Compare" style="display: none;">
                                <td>
                                    <div style="width: 500px; float: left;">
                                        <div style="float: left; width: 68px;">Từ ngày</div>
                                        <div style="float: left;">
                                            <asp:TextBox ID="txt_day_form_Com" runat="server" TabIndex="3" Width="100px" Height="21px"></asp:TextBox>
                                            <cc2:CalendarExtender ID="CalendarExtender3" Format="dd/MM/yyyy" PopupPosition="BottomRight"
                                                runat="server" TargetControlID="txt_day_form_Com"></cc2:CalendarExtender>
                                        </div>
                                        <div style="width: 68px; float: left; margin-left: 90px;">
                                            Đến ngày
                                        </div>
                                        <div style="float: left;">
                                            <asp:TextBox ID="txt_day_to_Com" runat="server" Width="100px" Height="21px" TabIndex="4"></asp:TextBox>
                                            <cc2:CalendarExtender ID="CalendarExtender4" Format="dd/MM/yyyy" PopupPosition="BottomRight"
                                                runat="server" TargetControlID="txt_day_to_Com"></cc2:CalendarExtender>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="5">
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
         <script type="text/javascript">
             function pageLoad(sender, args) {
                 var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                 for (var selector in config) { $(selector).chosen(config[selector]); }
             }
    </script>
    <script>
        function Validate() {
            return true;
        }
    </script>
</asp:Content>
