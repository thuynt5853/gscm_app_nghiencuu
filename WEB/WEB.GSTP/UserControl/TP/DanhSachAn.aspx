<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DanhSachAn.aspx.cs" Inherits="WEB.GSTP.UserControl.TP.DanhSachAn" %>

<!DOCTYPE html>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../../UI/css/style.css" rel="stylesheet" />
    <link href="../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../UI/css/jquery-ui.css" rel="stylesheet" />

    <script src="../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../UI/js/jquery-ui.min.js"></script>

    <script src="../../UI/js/chosen.jquery.js"></script>
    <script src="../../UI/js/init.js"></script>
    <script src="../../UI/js/jquery.enhsplitter.js"></script>
    <script src="../../UI/js/Common.js"></script>
    <title>Danh sách vụ án/vụ việc</title>
    <style>
        body {
            width: 100%;
            min-width: 0px;
        }

        .content_popup {
            width: 97%;
            margin: 15px 1.5%;
            float: left;
            position: relative;
            height: 720px;
            overflow-y: auto;
        }

        .title_group {
            margin-bottom: 10px;
            text-transform: uppercase;
            font-size: 18px;
            font-weight: bold;
            float: left;
            width: 60%;
        }
        /*---------------------------------------*/
        .content_form_head {
            background: linear-gradient(to right,#980305, #b5100c,#ffaaaa,#fff);
            float: left;
            width: 100%;
            height: 40px;
            border-radius: 4px 4px 0px 0px;
        }

        .content_form_head_title {
            color: white;
            float: left;
            font-size: 13pt;
            font-weight: bold;
            line-height: 40px;
            margin-left: 20px;
            text-transform: uppercase;
        }

        .content_form_head_right {
            float: right;
        }

        .content_body {
            float: left;
            margin-bottom: 19px;
            background: white;
            box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);
            border-radius: 4px;
        }

        .content_form_body {
            float: left;
            margin: 20px 2%;
            width: 96%;
        }

        .LbtBack_css {
            background: url("close.png");
            width: 32px;
            height: 32px;
            margin-right: 15px;
            margin-top: 5px;
        }

        .table2 .header {
            text-align: center;
        }

        .buttoninput_CA_Home_css {
            min-width: 80px;
            height: 30px;
            font-weight: bold;
            color: #631313;
            background: url("/UI/img/bg_danhsach.png");
            padding-left: 15px;
            padding-right: 15px;
            cursor: pointer;
            border: solid 1px #9e9e9e;
            border-radius: 3px 3px 3px 3px;
        }

            .buttoninput_CA_Home_css a {
                height: 30px;
            }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                <div id="div_Content" runat="server" class="content_popup content_body" style="height: 95vh;">
                    <div class="content_form_head">
                        <div class="content_form_head_title">Danh sách vụ án/vụ việc</div>
                        <div class="content_form_head_right">
                            <asp:LinkButton ID="LbtBackHome" runat="server" OnClick="LbtBackHome_Click"><div class="LbtBack_css" title="Quay lại"></div></asp:LinkButton>
                        </div>
                    </div>
                    <div class="content_form_body">
                        <table class="table1">
                            <tr>
                                <td style="width: 135px; font-weight: bold; font-size: 14px;">Cấp xét xử:</td>
                                <td style="font-size: 14px;">
                                    <asp:Literal ID="LtrCapXetXu" runat="server" Text=""></asp:Literal></td>
                                <td rowspan="3">
                                    <asp:Button ID="cmdInBaoCao" runat="server" CssClass="buttoninput_CA_Home_css" Style="float: right;" Text="In báo cáo" OnClick="cmdInBaoCao_Click" />
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 135px; font-weight: bold; font-size: 14px;">Loại án:</td>
                                <td style="font-size: 14px;">
                                    <asp:Literal ID="LtrLoaiAn" runat="server" Text=""></asp:Literal></td>
                            </tr>
                            <tr>
                                <td style="width: 135px; font-weight: bold; font-size: 14px;">Thông tin thống kê:</td>
                                <td style="font-size: 14px;">
                                    <asp:Literal ID="LtrThongTinThongKe" runat="server" Text=""></asp:Literal></td>
                            </tr>
                        </table>
                        <div style="margin-bottom: 10px; margin-top: 10px; font-weight: bold; color: red; float: left; width: 100%;">
                            <asp:Literal ID="LtrThongBao" runat="server"></asp:Literal>
                        </div>
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
                        <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                            PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                            CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                            ItemStyle-CssClass="chan" Width="100%">
                            <Columns>
                                <asp:TemplateColumn HeaderStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>TT</HeaderTemplate>
                                    <ItemTemplate><%#Container.DataSetIndex + 1 %></ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:BoundColumn DataField="MAVUVIEC" HeaderText="Mã vụ án / vụ việc" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                <asp:BoundColumn DataField="TENVUVIEC" HeaderText="Tên vụ án / vụ việc" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                            </Columns>
                            <HeaderStyle CssClass="header"></HeaderStyle>
                            <ItemStyle CssClass="chan"></ItemStyle>
                            <PagerStyle Visible="false"></PagerStyle>
                        </asp:DataGrid>
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
                    </div>
                </div>
                <script type="text/javascript">
                    function popup_inbaocao_danhsach() {
                        var link = "/UserControl/TP/Inbaocao_Danhsach.aspx";
                        var width = 1000;
                        var height = 800;
                        PopupCenter(link, "In báo cáo danh sách vụ án / vụ việc.", width, height);
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
