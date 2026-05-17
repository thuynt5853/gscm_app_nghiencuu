<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DongBoDuongSu.aspx.cs" Inherits="WEB.GSTP.QLAN.C12.DongBoDuongSu" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title><%# columnDynamic %></title>
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

        
        .btn-break {
            display: block;
            margin-bottom: 8px;
        }

        .info-box {
            border: 1px solid #d0d7de;
            border-radius: 8px;
            padding: 15px 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .info-item {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
            font-size: 14px;
        }

        .info-item:last-child {
            margin-bottom: 0;
        }

        .info-label {
            font-weight: 600;
            color: #333;
            min-width: 140px;
            margin-right: 10px;
        }

        .info-value {
            font-weight: 500;
        }
    </style>
    <form id="form1" runat="server">
        <div class="boxchung">

            <div>

                <div class="info-box">
            <div class="info-item">
                <span class="info-label">Số BAQD:</span>
                <asp:Label ID="lblSoBAQD" runat="server" CssClass="info-value" />
            </div>
            <div class="info-item">
                <span class="info-label">Ngày BAQD:</span>
                <asp:Label ID="lblNgayBAQD" runat="server" CssClass="info-value" />
            </div>
            <div class="info-item">
                <span class="info-label">Ngày hiệu lực:</span>
                <asp:Label ID="lblNgayHieuLuc" runat="server" CssClass="info-value" />
            </div>
        </div>
        <div style="display: flex; align-items: center; margin-top: 20px; gap: 20px;">

            <!-- KHỐI TRẠNG THÁI -->
            <div style="display: flex; align-items: center; gap: 10px;">
                <label style="width: 130px; text-align: right; font-weight: 600;">
                    Trạng thái đồng bộ
                </label>

                <asp:DropDownList ID="ddlTrangthaiDongBo" runat="server"
                    CssClass="chosen-select"
                    Width="220px"
                    AutoPostBack="True"
                    OnSelectedIndexChanged="ddlTrangthaiDongBo_SelectedIndexChanged">
                    <asp:ListItem Value="0" Text="Tất cả" Selected="True"></asp:ListItem>
                    <asp:ListItem Value="1" Text="Chưa đồng bộ"></asp:ListItem>
                    <asp:ListItem Value="2" Text="Đang đồng bộ"></asp:ListItem>
                    <asp:ListItem Value="3" Text="Đã đồng bộ"></asp:ListItem>
                    <asp:ListItem Value="4" Text="Bị thu hồi"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <!-- KHỐI TÌM KIẾM -->
            <div style="display: flex; align-items: center; gap: 10px;">
                <asp:TextBox ID="txtSearch" CssClass="user" runat="server" Width="200px"></asp:TextBox>

                <asp:Button ID="Button1" runat="server"
                    CssClass="buttoninput"
                    Text="Tìm kiếm"
                    OnClick="btnSearch_Click" />
            </div>

        </div>

        <asp:Panel ID="pn_thuhoi" runat="server" Visible="true" Style="margin-right: 20px;margin-top:10px">
                <div style="display: flex; align-items: center;">
                    <asp:TextBox ID="txtLyDoThuHoi" CssClass="user" runat="server" Width="240px"
                        placeholder="Nhập lý do thu hồi..." Style="margin-right: 10px;"></asp:TextBox>
                    <asp:Button ID="btnThuHoi" runat="server" CssClass="buttoninput"
                        Text="Thu hồi" OnClick="btnThuHoi_Click" OnClientClick="return validateThuHoi();" />
                </div>
            </asp:Panel>
        
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
        
                <br />
                <asp:DataGrid ID="DgList_All" runat="server" AutoGenerateColumns="False" CellPadding="4"
                    PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                    ItemStyle-CssClass="chan" Width="100%" OnItemCommand="DgList_All_ItemCommand" OnItemDataBound="DgList_All_ItemDataBound">
                    <Columns>
                        <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center">
                            <HeaderTemplate>STT</HeaderTemplate>
                            <ItemTemplate><%#Eval("STT")%></ItemTemplate>
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkChon" runat="server" AutoPostBack="true"
                     OnCheckedChanged="chkChon_CheckedChanged" ToolTip='<%#Eval("DUONGSUID") +","+ Eval("KHOBAQDID")+"," + Eval("TRANGTHAIDUONGSU")+"," + Eval("ID") +"," + Eval("TRANGTHAIBAQD")%>' />
                            </ItemTemplate>
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="300px">
                            <HeaderTemplate><%# columnDynamic %></HeaderTemplate>
                            <ItemTemplate>
                                <div><%#Eval("TENDUONGSU")%></div>
                                <div><%#Eval("NGAYSINH")%></div>
                                <div><%#Eval("SO_CCCD")%></div>
                            </ItemTemplate>
                        </asp:TemplateColumn>

                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="200px">
                            <HeaderTemplate>Kết quả đồng bộ</HeaderTemplate>
                            <ItemTemplate>
                                <div style="width: 300px"><%#Eval("NOIDUNG_DONGBO")%></div>
                            </ItemTemplate>
                        </asp:TemplateColumn>
                         <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="150px">
                            <HeaderTemplate>Lý do</HeaderTemplate>
                            <ItemTemplate>
                                <div style="width: 200px"><%#Eval("GHICHU")%></div>
                            </ItemTemplate>
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderText="Thao tác" HeaderStyle-Width="200px">
                            <ItemTemplate>
                                <asp:LinkButton ID="LinkButtonDuongSuDongBo" runat="server" CausesValidation="false" Text="Đồng bộ" Font-Bold="true" ForeColor="#0e7eee" CommandName="DongBo" CommandArgument='<%#Eval("DUONGSUID") +","+ Eval("KHOBAQDID")+"," + Eval("TRANGTHAIDUONGSU")+"," + Eval("ID") +"," + Eval("TRANGTHAIBAQD")%>'
                                    ToolTip="Đồng bộ" OnClientClick="return confirm('Bạn có chắc muốn đồng bộ lại không?');" CssClass="btn-break"></asp:LinkButton>

                                <asp:LinkButton ID="LinkButtonXemGuiLai" runat="server" CausesValidation="false" Text="Gửi lại" Font-Bold="true" ForeColor="#0e7eee" CommandName="GuiLai" CommandArgument='<%#Eval("DUONGSUID") +","+ Eval("KHOBAQDID")+"," + Eval("TRANGTHAIDUONGSU")+"," + Eval("ID") +"," + Eval("TRANGTHAIBAQD")%>'
                                    ToolTip="Gửi lại" OnClientClick="return confirm('Bạn có chắc gửi lại không? Bạn phải chịu trách nhiệm về hành động này?');" CssClass="btn-break"></asp:LinkButton>

                                <asp:LinkButton ID="LinkButtonHuyChuyen" runat="server" Text="Hủy chuyển"
                                    CommandName="HuyChuyen"
                                    CommandArgument='<%#Eval("DUONGSUID") +","+ Eval("KHOBAQDID")+"," + Eval("TRANGTHAIDUONGSU")+"," + Eval("ID") +"," + Eval("TRANGTHAIBAQD")%>'
                                    OnClientClick="return confirm('Bạn có chắc muốn hủy chuyển không?');" CssClass="btn-break" />
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
<script>


    function validateThuHoi() {
        var txtLyDoThuHoi = document.getElementById('<%=txtLyDoThuHoi.ClientID%>');
        if (txtLyDoThuHoi.value == '') {
            alert('Chưa nhập Lý do thu hồi. Hãy nhập lại!');
            txtLyDoThuHoi.focus();
            return false;
        }

        return confirm('Bạn có chắc muốn thu hồi dữ liệu không?');;

    }
</script>
</html>
