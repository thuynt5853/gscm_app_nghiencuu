<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/AN_PHI.Master" AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs" Inherits="WEB.TP.Quantri.DON_VI.Danhsach" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="content_form">
        <div class="content_body">
            <div class="content_form_head">
                <div class="content_form_head_title">DANH SÁCH ĐƠN VỊ</div>
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
                            <asp:ListItem Value="0" Selected="True" Text="Bao gồm cấp con"></asp:ListItem>
                            <asp:ListItem Value="1" Text="Chỉ thuộc đơn vị"></asp:ListItem>
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
                            <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                            <asp:BoundColumn DataField="ARRSAPXEP" Visible="false"></asp:BoundColumn>
                            <asp:TemplateColumn ItemStyle-Width="40px" HeaderStyle-Width="40px" ItemStyle-HorizontalAlign="Center"
                                HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                <HeaderTemplate>
                                    TT
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("STT")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <%--           <asp:TemplateColumn ItemStyle-Width="250px" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                <HeaderTemplate>
                                   CHI CỤC THA
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("TEN")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>--%>
                            <asp:TemplateColumn ItemStyle-Width="300px" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                <HeaderTemplate>
                                    TÊN CỤC, CHI CỤC THA
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("MA_TEN")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                                       <asp:TemplateColumn ItemStyle-Width="200px" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                <HeaderTemplate>
                                    TÊN TK THỤ HƯỞNG 
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("TEN_TK_THUHUONG")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn ItemStyle-Width="200px" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                <HeaderTemplate>
                                    ĐỊA CHỈ ĐƠN VỊ
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("DIACHI")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn ItemStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                <HeaderTemplate>
                                    ĐIỆN THOẠI 
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("DIENTHOAI")%>
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
                                    SỐ TÀI KHẢN
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("SOTK_KHOBAC")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn ItemStyle-Width="170px" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                <HeaderTemplate>
                                    TÊN KHO BẠC
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("TENTK_KHOBAC")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn ItemStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                <HeaderTemplate>
                                    MÃ KHO BẠC
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("MA_KHOBAC")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn ItemStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                <HeaderTemplate>
                                    MÃ LOẠI HÌNH THU
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("MALOAIHINHTHU")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn ItemStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                <HeaderTemplate>
                                    TÊN LOẠI HÌNH THU
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("TENLOAIHINHTHU")%>
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
                            <asp:TemplateColumn HeaderStyle-Width="50px" ItemStyle-Width="80px" HeaderStyle-HorizontalAlign="Center">
                                <HeaderTemplate>
                                    Thao tác
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <a class="link_nopap" href="javascript:;" style="color: #0E7EEE" onclick="nopanphi('<%#Eval("ID")%>','<%#Eval("ID_TT")%>','<%#Eval("ID_LHT")%>')">Sửa</a>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
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
    <script type="text/javascript">          
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
        function nopanphi(_ID, _ID_TT, _ID_LHT) {
            var link = "Capnhat.aspx?donviID=" + _ID + "&ID_TT=" + _ID_TT + "&ID_LHT=" + _ID_LHT;
            var width = 850;
            var height = 770;
            OpenPopupCenter(link, "Nộp án phí", width, height);
        }
        function OpenPopupCenter(pageURL, title, w, h) {
            var left = (screen.width / 2) - (w / 2);
            var top = (screen.height / 2) - (h / 2);
            var targetWin = window.open(pageURL, title, 'toolbar=no,scrollbars=yes,resizable=yes,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            return targetWin;
        }
        function Loadds_tha() {
            $("#<%= cmdTimkiem.ClientID %>").click();
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
</asp:Content>
