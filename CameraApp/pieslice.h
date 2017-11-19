#ifndef PIESLICE_H
#define PIESLICE_H

#include <QQuickPaintedItem>

class MenuPieSlice : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(double arcLength READ arcLength WRITE setArcLength NOTIFY arcLengthChanged)
    Q_PROPERTY(double innerRadius READ innerRadius WRITE setInnerRadius NOTIFY innerRadiusChanged)
    Q_PROPERTY(double shadowRadius READ shadowRadius WRITE setShadowRadius NOTIFY shadowRadiusChanged)
public:
    MenuPieSlice();

    double arcLength() const;
    double innerRadius() const;
    double shadowRadius() const;
    void setArcLength(double newArcLength);
    void setInnerRadius(double newInnerRadius);
    void setShadowRadius(double newShadowRadius);

    void paint(QPainter *painter);
signals:
    void arcLengthChanged();
    void innerRadiusChanged();
    void shadowRadiusChanged();

public slots:
private:
    double mArcLength;
    double mInnerRadius;
    double mShadowRadius;
};

#endif // PIESLICE_H
