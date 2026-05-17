<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LichSuDongBo.aspx.cs" Inherits="WEB.GSTP.QLAN.C12.LichSuDongBo" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lịch sử đồng bộ</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
</head>
<body>
    <style type="text/css">
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
            overflow-y: auto;
            overflow-x: auto;
        }

        .Lable_Popup_Add_VV {
            width: 117px;
        }

        .Input_Popup_Add_VV {
            width: 250px;
        }

        #form1 {
            margin-left: 20px;
        }
    </style>
    <form id="form1" runat="server">

        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="phantrang">
            <div class="sobanghi">
                <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
            </div>
            <div class="sotrang">
                <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false"
                    CssClass="back" Visible="true"
                    OnClick="lbTBack_Click">
                </asp:LinkButton>
                <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                    Text="1" OnClick="lbTFirst_Click">
                </asp:LinkButton>
                <asp:Label ID="lbTStep1" runat="server" Text="..." Visible="false"></asp:Label>
                <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                    Text="2" OnClick="lbTStep_Click">
                </asp:LinkButton>
                <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                    Text="3" OnClick="lbTStep_Click">
                </asp:LinkButton>
                <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                    Text="4" OnClick="lbTStep_Click">
                </asp:LinkButton>
                <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                    Text="5" OnClick="lbTStep_Click">
                </asp:LinkButton>
                <asp:Label ID="lbTStep6" runat="server" Text="..." Visible="false"></asp:Label>
                <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                    Text="100" OnClick="lbTLast_Click">
                </asp:LinkButton>
                <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                    OnClick="lbTNext_Click">
                </asp:LinkButton>
                <asp:DropDownList ID="DropDownList1" runat="server" Width="55px" CssClass="so"
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
        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
        <div class="boxchung">

            <div>
                <asp:DataGrid ID="DgList_All" runat="server" AutoGenerateColumns="False" CellPadding="4"
                    PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                    ItemStyle-CssClass="chan" Width="100%">
                    <Columns>
                        <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center">
                            <HeaderTemplate>STT</HeaderTemplate>
                            <ItemTemplate><%#Eval("STT")%></ItemTemplate>
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                            <HeaderTemplate>Ngày</HeaderTemplate>
                            <ItemTemplate><%#Eval("NGAY")%></ItemTemplate>
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="200px">
                            <HeaderTemplate>Kết quả</HeaderTemplate>
                            <ItemTemplate>
                                <div style=""><%#Eval("KETQUA")%></div>
                            </ItemTemplate>
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="150px">
                            <HeaderTemplate>Lý do</HeaderTemplate>
                            <ItemTemplate>
                                <div style="width: 200px"><%#Eval("GHICHU")%></div>
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
                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false"
                        CssClass="back" Visible="true"
                        OnClick="lbTBack_Click">
                    </asp:LinkButton>
                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false"
                        CssClass="active" Visible="false"
                        Text="1" OnClick="lbTFirst_Click">
                    </asp:LinkButton>
                    <asp:Label ID="lbBStep1" runat="server" Text="..." Visible="false"></asp:Label>
                    <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                        Text="2" OnClick="lbTStep_Click">
                    </asp:LinkButton>
                    <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                        Text="3" OnClick="lbTStep_Click">
                    </asp:LinkButton>
                    <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                        Text="4" OnClick="lbTStep_Click">
                    </asp:LinkButton>
                    <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                        Text="5" OnClick="lbTStep_Click">
                    </asp:LinkButton>
                    <asp:Label ID="lbBStep6" runat="server" Text="..." Visible="false"></asp:Label>
                    <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                        Text="100" OnClick="lbTLast_Click">
                    </asp:LinkButton>
                    <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                        OnClick="lbTNext_Click">
                    </asp:LinkButton>
                    <asp:DropDownList ID="dropPageSize" runat="server" Width="55px" CssClass="so"
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
        </div>

    </form>
</body>
<script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
<script src="/UI/js/jquery.enhsplitter.js"></script>
</html>
