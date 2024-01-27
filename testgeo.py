from django.test import TestCase
from django.contrib.gis.geos import Point
from .models import GeoPoint

class GeoPointModelTest(TestCase):
    def setUp(self):
        self.point = GeoPoint.objects.create(name='Test Point', location='POINT(30 40)')

    def test_geo_point_creation(self):
        self.assertEqual(self.point.name, 'Test Point')
        self.assertEqual(str(self.point.location), 'POINT (30.0 40.0)')

    def test_spatial_query(self):
        reference_point = Point(30, 40)
        nearby_points = GeoPoint.objects.filter(location__distance_lte=(reference_point, 10))
        self.assertIn(self.point, nearby_points)