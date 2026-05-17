<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="User_Infor_his.aspx.cs" Inherits="WEB.TP.User_Infor_his" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
     <link href="/UI/css/TAble.css" rel="stylesheet" />
    <link href="/UI/css/paging.css" rel="stylesheet" />
    <link href="../../../UI/css/style.css" rel="stylesheet" />
    <script src="../../../UI/js/Common.js"></script>
    <script type="text/javascript" src="/UI/js/base64.js"></script>
    <script type="text/javascript" src="/UI/js/vgcaplugin.js"></script>

    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    <title></title>
    <style>
        .content_body {
            width: 96%;
            margin: 20px 2%;
        }

        .cell_label {
            margin-left: 5px;
        }

        .buttoninput {
            float: left;
            margin-right: 8px;
            padding: 5px 10px 6px 10px;
            box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);
            background: #d02629;
            border-radius: 5px;
            color: white;
            cursor: pointer;
            font-size: 15px;
            font-weight: bold;
            border: medium none;
        }

        .buttondisable {
            float: left;
            margin-right: 8px;
            padding: 5px 10px 6px 10px;
            box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="Ajax_Manager_Updata" runat="server">
            <ContentTemplate>
                <div class="content_form">
                    <div class="content_body">
                        <div class="content_form_head">
                            <div class="content_form_head_title">Lịch sử cập nhật thông tin</div>
                            <div class="content_form_head_right"></div>
                        </div>
                        <div class="content_form_body">
                            <div style="float: left; width: 100%">
                                <div style="float: left; padding-top: 5px; font-weight: bold; width: 150px;">Chọn đơn vị</div>
                                <div style="float: left; margin-left: 10px;">
                                    <asp:DropDownList CssClass="chosen-select" ID="ddlDonvi" runat="server" Width="500px">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div style="float: left; width: 100%; margin-top: 8px;">
                                <div style="float: left; padding-top: 5px; font-weight: bold; width: 150px;">Phạm vi tìm kiếm</div>
                                <div style="float: left; margin-left: 10px;">
                                    <asp:DropDownList CssClass="chosen-select" ID="ddlLoaiNhom" runat="server" Width="250px">
                                        <asp:ListItem Value="0" Text="Bao gồm cấp con"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Chỉ thuộc đơn vị" Selected="True"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div style="float: left; width: 100%; margin-top: 20px;">
                                <div style="float: left; margin-left: 160px;">
                                    <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                                </div>
                            </div>
                            <div class="msg_thongbao">
                                <asp:Literal ID="lbthongbao" runat="server"></asp:Literal>
                            </div>
                            <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                            <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                        OnClick="lbTBack_Click"><</asp:LinkButton>
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
                                        OnClick="lbTNext_Click">></asp:LinkButton>
                                    <asp:DropDownList ID="dropPageSize" runat="server" Width="65px"
                                        CssClass="dropbox"
                                        AutoPostBack="True" OnSelectedIndexChanged="dropPageSize_SelectedIndexChanged">
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
                            <div>
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" GridLines="None"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%">
                                    <Columns>
                                        <asp:TemplateColumn ItemStyle-Width="40px" HeaderStyle-Width="40px" ItemStyle-HorizontalAlign="Center"
                                            HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                            <HeaderTemplate>
                                                TT
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("STT")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn ItemStyle-Width="180px" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                            <HeaderTemplate>
                                                TÊN TÀI KHOẢN THỤ HƯỞNG
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TEN_TK_THU_HUONG")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn ItemStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                            <HeaderTemplate>
                                                MÃ ĐỊNH DANH
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("MA_DINH_DANH")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn ItemStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                            <HeaderTemplate>
                                                SỐ TÀI KHẢN KHO BÁC
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("SO_TK")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn ItemStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                            <HeaderTemplate>
                                                MÃ KHO BẠC
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("MA_KHO_BAC")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                          <asp:TemplateColumn ItemStyle-Width="200px" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                            <HeaderTemplate>
                                                TÊN KHO BẠC
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TEN_KHO_BAC")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn ItemStyle-Width="250px" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                            <HeaderTemplate>
                                                ĐỊA CHỈ ĐƠN VỊ
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("DIA_CHI")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn ItemStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                            <HeaderTemplate>
                                                ĐIỆN THOẠI 
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("DIEN_THOAI")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn ItemStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                            <HeaderTemplate>
                                                Email
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("EMAIL")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn ItemStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                            <HeaderTemplate>
                                                Người sửa
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("NGUOI_SUA")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn ItemStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                            <HeaderTemplate>
                                                NGÀY SỬA
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("NGAY_SUA")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                </asp:DataGrid>
                            </div>
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                        OnClick="lbTBack_Click"><</asp:LinkButton>
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
                                        OnClick="lbTNext_Click">></asp:LinkButton>
                                    <asp:DropDownList ID="dropPageSize2" runat="server" Width="65px" CssClass="dropbox"
                                        AutoPostBack="True" OnSelectedIndexChanged="dropPageSize2_SelectedIndexChanged">
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
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="Ajax_Manager_Updata">
            <ProgressTemplate>
                <div class="processmodal">
                    <div class="processcenter">
                        <img src="/UI/img/process.gif" />
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <script type="text/javascript">          
            function pageLoad(sender, args) {
                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            }
        </script>
        <style>
            table {
                border-width: 0;
                border-collapse: collapse;
                border-spacing: 0;
            }

            .table1 {
                width: 100%;
            }

            .table2 td {
                border: solid 1px #a2c2a8;
                padding: 5px;
                line-height: 17px;
            }

            .table1 td {
                padding: 2px;
                padding-left: 2px;
                padding-left: 5px;
                vertical-align: middle;
            }

            .table2 .header {
                font-weight: bold;
                color: #ffffff !important;
            }

            .header td {
                color: #ffffff;
            }

            .content_form_body {
                margin: 10px 10px 10px 30px;
                width: 95%;
            }

            .next {
                background: url(/UI/img/next.png) no-repeat center 5px;
            }

            .back {
                background: url(/UI/img/back.png) no-repeat center 5px;
            }

            .back, .top, .so, .next, .end, .active {
                border: 1px #bfbfbf solid;
                padding: 2px 6px;
                color: #434343;
                line-height: 20px;
                text-decoration: none;
                margin-right: 3px;
                border-radius: 6px;
                background-color: #e9e9e9;
            }

            .active {
                border: solid 1px #053281;
                color: #053281;
                font-weight: bold;
                background-color: white;
            }
        </style>

    </form>
</body>
</html>
<script src="../../../UI/js/init.js"></script>
<script src="/UI/js/chosen.jquery.js"></script>
